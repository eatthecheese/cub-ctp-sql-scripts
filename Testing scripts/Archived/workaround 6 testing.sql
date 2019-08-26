-- ============= Undercharging no SAF ==============
-- VERSION 0.3.2 DST ENDED
-- set startdate
with StartDate as (
    select 
--       DST ended on 7 April
        TO_DATE('07/APR/2019 00:00:00') startdate
    from dual
),
-- get data set 
data as (
    select 
        Trip_ID, 
        transit_account_id,
        token_id,
        entry_stop_id,
        entry_transaction_DTM,
        exit_stop_id,
        exit_transaction_DTM,
        calculated_fare,
        calculated_fee,
        fare_due,
        cap_amt
    from abp_main.trip
    where 
        entry_transaction_dtm +10/24 >= (SELECT * FROM StartDate) +3/24
        AND entry_transaction_dtm +10/24 <= sysdate
        AND void_type is null
),
daily_total as (
    SELECT 
        trip_id,
        data.entry_transaction_dtm +10/24 as day,
        entry_stop_id,
        exit_stop_id,
        token_id, 
        transit_account_id,
        (calculated_fare-calculated_fee) as calculated_fare_wo_SAF,
        calculated_fare as calculated_fare_w_SAF,
        cap_amt,
        (fare_due-calculated_fee) As fare_paid_wo_SAF
    FROM data
    where calculated_fare != 0
),
daily_report_detailed as (
    select 
        trip_id,
        day,
        to_char(day-(4/24),'DAY', 'NLS_DATE_LANGUAGE=''numeric date language''') as business_day_of_the_week,
        token_id,
        transit_account_id,
        calculated_fare_wo_SAF,
        fare_paid_wo_SAF,
        cap_amt,
        sum(fare_paid_wo_SAF) over (partition by trunc(day-4/24,'dd'), token_id order by day, token_id) running_daily_fare,
        sum(fare_paid_wo_SAF) over (partition by trunc(day-4/24,'dd'), token_id) total_daily_fare,
        sum(calculated_fare_wo_SAF) over (partition by trunc(day-4/24,'dd'), token_id) total_calculated_fare,
        sum(cap_amt) over (partition by trunc(day-4/24,'dd'), token_id) total_cap_amount
    from daily_total 
    
    --where fare_paid_wo_SAF != 0
    order by token_id, day desc
),
journal as (
    select 
        * 
    from abp_main.journal_entry
    where transaction_dtm >= (select * from startdate)
    order by capping_scheme_description
), 
daily_underpaid as (
    select 
        drd.*,
        (case 
            when business_day_of_the_week = 7 then
                (case
                    when drd.total_daily_fare < 270 and drd.total_cap_amount > 0 then -- total paid < cap but total cap applied > 0 (i.e. capping applied)
                    -- where capping amt != 0 and running total < cap
                        (case
                            when drd.cap_amt != 0 and drd.running_daily_fare < 270 then 
                                (case
                                -- when fare is larger than cap then undercharged by difference to cap
                                    when fare_paid_wo_SAF > 270 then 270 - cap_amt
                                    -- when cap amount is larger than cap amount + running daily fare, then undercharged by difference of running_daily_fare to 270 (maxed out)
                                    when running_daily_fare + cap_amt > 270 then 270 - running_daily_fare
                                    else cap_amt
                                end)                                
                            else 0
                        end)
                    else 0
                end)
            else 
                (case
                    when drd.total_daily_fare < 1580 and drd.total_cap_amount > 0 then -- total paid < cap but total cap applied > 0 (i.e. capping applied)
                    -- where capping amt != 0 and running total < cap
                        (case
                            when drd.cap_amt != 0 and drd.running_daily_fare < 1580 then
                                (case
                                -- when fare is larger than cap then undercharged by difference to cap
                                    when fare_paid_wo_SAF > 1580 then 1580 - cap_amt
                                    -- when cap amount is larger than cap amount + running daily fare, then undercharged by difference of running_daily_fare to 1580 (maxed out)
                                    when running_daily_fare + cap_amt > 1580 then 1580 - running_daily_fare
                                    else cap_amt
                                end)     
                            else 0
                        end)
                    else 0
                end)
        end) as underpaid_amount,
        (select capping_scheme_description 
        from journal je 
        where drd.trip_id = je.trip_id 
        and rownum = 1
        ) as capping_scheme
    from daily_report_detailed drd
),
-- check if any trips were undercharged multiple times, and evaluate if daily cap was reached. if so, only count undercharges up to the daily cap
daily_capped_check as (
select du.*,
  running_daily_fare + sum(underpaid_amount) over (partition by trunc(day-4/24,'dd'), token_id order by day, token_id) running_paid_amount_total,
  (case
      when business_day_of_the_week = 7 then
          (case
              when running_daily_fare + sum(underpaid_amount) over (partition by trunc(day-4/24,'dd'), token_id order by day, token_id) > 270 then 'Y'
              else 'N'
          end)
      else
          (case
              when running_daily_fare + sum(underpaid_amount) over (partition by trunc(day-4/24,'dd'), token_id order by day, token_id) > 1580 then 'Y'
              else 'N'
          end)
  end) as dailycapped
from daily_underpaid du
),
daily_sum_underpaid as (
select dcc.*,
      (case
            when dailycapped = 'N' then underpaid_amount
            else 
                (case
                    when business_day_of_the_week = 7 then
                        (case 
                            when running_paid_amount_total - underpaid_amount > 270 then 0
                            else 270 - (running_paid_amount_total - underpaid_amount)
                        end)
                    else
                        (case 
                            when running_paid_amount_total - underpaid_amount > 1580 then 0
                            else 1580 - (running_paid_amount_total - underpaid_amount)
                        end)
                end)
      end)
 as underpaid_amount_final
from daily_capped_check dcc
)
select 
--   *
   count(*),
   sum(underpaid_amount_final)
from daily_sum_underpaid
where underpaid_amount != 0
--and fare_paid_wo_saf = 0
and capping_scheme is not null
and capping_scheme not like '%Weekly%Cap%'
order by day
;