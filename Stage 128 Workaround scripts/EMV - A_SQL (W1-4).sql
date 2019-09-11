--on EMV prod
-- get current day of the week
with dow as (
    select 
       to_char(sysdate,'DAY',
       'NLS_DATE_LANGUAGE=''numeric date language''') dayoftheweek
    from dual
),
-- get last monday (up 6 for 1 week, up to)
StartDate as (
    select 
        trunc(sysdate,'DD')-6 -(select * from dow) startdate
    from dual
),
deny_list_detailed as (
    select 
        t3.TAPID, 
        t3.TOKENID,
        t3.TRANSITACCOUNTID,
        t3.STOPID,
        t3.PREV_TAPID,
        t3.PREV_TAPSTATUSID, 
        t3.PREV_TRANSACTIONDTM, 
        t3.PREV_DIFF, 
        t3.PREV_STOPID,
        t3.TAPSTATUSID, 
        t3.TRANSACTIONDTM,
        t3.NEXT_TAPID,
        t3.NEXT_TAPSTATUSID,
        t3.NEXT_TRANSACTIONDTM,
        t3.NEXT_STOPID,
        t.DEFAULTFAREFLAG as DEFAULTFARE,
        t.FAREDUE,
        (case when ram.apportionedoperatorid = '44' then '44 - Sydney Trains'
        when  ram.apportionedoperatorid = '45' then '45 - NSW Trainlink'
        when ram.apportionedoperatorid = '37' then '37 - Metro Trains Sydney'
        when opr.ETSOPERATORID = '1' then '1 - Sydney Ferries'
        when opr.ETSOPERATORID = '46' then '46 - Sydney Light Rail'
        when opr.ETSOPERATORID = '38' then '38 - Newcastle Transport'
        when rvt.ETSSUBSYSTEMID is not null then TO_CHAR(bso.ETSSUBSYSTEMID) || ' - ' || TO_CHAR(bso.ETSBUSOPERATORNAME)
        else 'No idea'
        end) as Apportioned_ETS_Operator
    from (
        select 
            TAPID, 
            EMPLOYEEID,
            ROUTENUM,
            TOKENID,
            TRANSITACCOUNTID,
            TRIPID,
            STOPID,
            PREV_TAPID,
            PREV_TAPSTATUSID,
            PREV_TRANSACTIONDTM+11/24 as PREV_TRANSACTIONDTM, 
            SUBSTR((TRANSACTIONDTM - PREV_TRANSACTIONDTM),1,30) as PREV_DIFF, 
            PREV_STOPID,
            TAPSTATUSID, 
            TRANSACTIONDTM+11/24 as TRANSACTIONDTM,
            NEXT_TAPID,
            NEXT_TAPSTATUSID,
            NEXT_TRANSACTIONDTM+11/24 as NEXT_TRANSACTIONDTM,
            NEXT_STOPID
        from (
            select
                t1.TAPID,
                t1.EMPLOYEEID,
                t1.ROUTENUM,
                t1.DEVICEID,
                t1.TOKENID,
                t1.TRIPID,
                t1.TRANSITACCOUNTID,
                t1.STOPID,
                t1.TAPSTATUSID,
                t1.TAPSTATUSDESCRIPTION,
                t1.TRANSACTIONDTM,
                t1.ORIGINALTAPSTATUSID,
            LAG(TAPID) OVER (PARTITION BY TOKENID ORDER BY TOKENID, TRANSACTIONDTM) AS PREV_TAPID,
            LAG(TAPSTATUSID) OVER (PARTITION BY TOKENID ORDER BY TOKENID, TRANSACTIONDTM) AS PREV_TAPSTATUSID,
            LAG(TRANSACTIONDTM) OVER (PARTITION BY TOKENID ORDER BY TOKENID, TRANSACTIONDTM) AS PREV_TRANSACTIONDTM,
            LAG(STOPID) OVER (PARTITION BY TOKENID ORDER BY TOKENID, TRANSACTIONDTM) AS PREV_STOPID,
            LEAD(TAPID) OVER (PARTITION BY TOKENID ORDER BY TOKENID, TRANSACTIONDTM) AS NEXT_TAPID,
            LEAD(TAPSTATUSID) OVER (PARTITION BY TOKENID ORDER BY TOKENID, TRANSACTIONDTM) AS NEXT_TAPSTATUSID,
            LEAD(TRANSACTIONDTM) OVER (PARTITION BY TOKENID ORDER BY TOKENID, TRANSACTIONDTM) AS NEXT_TRANSACTIONDTM,
            LEAD(STOPID) OVER (PARTITION BY TOKENID ORDER BY TOKENID,TRANSACTIONDTM) AS NEXT_STOPID
            from EMV.tap t1
            where t1.TRANSACTIONDTM +11/24 >= trunc(sysdate-1, 'dd')+4/24  --replaced 20181206 based on email from Michael Tao
			AND t1.TRANSACTIONDTM +11/24 < trunc(sysdate, 'dd')+4/24  --added 20181206 based on email from Michael Tao
            AND not regexp_like(t1.DEVICEID, 'ABP')
            order by TAPID desc
        ) t2
        where 
        TAPSTATUSID = 4
        and STOPID = PREV_STOPID
        and ((PREV_TAPSTATUSID = 1 and NEXT_TAPSTATUSID = 4)
        OR (PREV_TAPSTATUSID = 1 and NEXT_TAPSTATUSID = 700)
        OR (PREV_TAPSTATUSID = 4 and NEXT_TAPSTATUSID = 700)
        OR (PREV_TAPSTATUSID = 1 and NEXT_TAPSTATUSID is null)
        OR (PREV_TAPSTATUSID = 4 and NEXT_TAPSTATUSID is null)
        )order by TOKENID, TRANSACTIONDTM asc
    ) t3
    right join EMV.TRIP t on t3.PREV_TAPID = t.ENTRYTAPID
    left join emv.ETS_RAIL_APPORTIONMENT_MATRIX ram on (t.ENTRYSTOPID = ram.ENTRYNLC and t.EXITSTOPID = ram.EXITNLC)
    left join emv.ETS_OPERATOR opr on (opr.NLC = t.ENTRYSTOPID)
    left join emv.ETS_BUS_ROUTE_VARIANT_V rvt on (t3.EMPLOYEEID = rvt.ETSBUSOPERATORID and t3.ROUTENUM = rvt.ROUTEVARIANT)
    left join emv.ETS_BUS_OPERATOR_DETAIL_V bso on (bso.ETSSUBSYSTEMID = rvt.ETSSUBSYSTEMID and bso.ETSBUSOPERATORID = rvt.ETSBUSOPERATORID)
    -- agreed to be 30
    where t3.PREV_DIFF < INTERVAL '30' MINUTE 
    --and default_fare_flag = 1
),
-- get data set (UTC time)
data as (
    select 
        TRIPID, 
        TRANSITACCOUNTID, 
        TOKENID,
        ENTRYTAPID,
        ENTRYTRANSACTIONDTM,
        ENTRYSTOPID,
        EXITTRANSACTIONDTM,
        EXITSTOPID,
        CALCULATEDFARE,
        CALCULATEDFEE,
        FAREDUE,
        PAIDAMT,
        CAPAMT,
        CAPPINGCHECKEDFLAG,
        DEFAULTFAREFLAG,
        sum (CALCULATEDFEE) over (partition by TOKENID order by ENTRYTRANSACTIONDTM, TOKENID) as ACCUMULATEDSAF
    from EMV.trip
    where 
        ENTRYTRANSACTIONDTM +11/24 >= (SELECT * FROM StartDate) +4/24 -0 --adjust data set left barrier here
        AND ENTRYTRANSACTIONDTM +11/24 <= sysdate
        AND VOIDFLAG = '0'
),
getRRN as (
        select
            je.TRIPID,
            bp.PGRETRIEVALREFNBR
        from EMV.BANKCARD_PAYMENT bp
        left join EMV.JOURNAL_ENTRY je
        on bp.BANKCARDPAYMENTID = je.BANKCARDPAYMENTID 
        where je.TRANSACTIONDTM +11/24 >= (SELECT * FROM StartDate) -0 -- adjust data set left barrier here
            AND je.TRANSACTIONDTM +11/24 <= sysdate
            and je.JOURNALENTRYTYPEID = 109
        order by bp.UPDATEDDTM desc
),
weekly_total as (
    SELECT 
        tr.TRIPID,
        (SELECT * FROM StartDate)+4/24 StartDate,
        trunc(sysdate,'DD') + 1 -0 - (select * from dow)+4/24 -1/86400 EndDate, -- adjust weekly barrier here
        tr.ENTRYTRANSACTIONDTM +11/24 as day,        
        tr.TOKENID, 
        tr.TRANSITACCOUNTID,
        (case when ram.apportionedoperatorid = '44' then '44 - Sydney Trains'
            when  ram.apportionedoperatorid = '45' then '45 - NSW Trainlink'
            when ram.apportionedoperatorid = '37' then '37 - Metro Trains Sydney'
            when opr.ETSOPERATORID = '1' then '1 - Sydney Ferries'
            when opr.ETSOPERATORID = '46' then '46 - Sydney Light Rail'
            when opr.ETSOPERATORID = '38' then '38 - Newcastle Transport'
            when rvt.ETSSUBSYSTEMID is not null then TO_CHAR(bso.ETSSUBSYSTEMID) || ' - ' || TO_CHAR(bso.ETSBUSOPERATORNAME)
            else 'No idea'
        end) as Apportioned_ETS_Operator,
        -- Check if SAF cap has reached, cap = $30.16 as of 2019Sep4
        (case when tr.ACCUMULATEDSAF < 3016 then FAREDUE - CALCULATEDFEE
            -- if SAF cap has just reached
            when  tr.ACCUMULATEDSAF >= 3016 and (tr.ACCUMULATEDSAF - tr.CALCULATEDFEE) < 3016 then FAREDUE - (3016 - (tr.ACCUMULATEDSAF - tr.CALCULATEDFEE))
            -- if SAF cap has reached prior
            when tr.ACCUMULATEDSAF >= 3016 and (tr.ACCUMULATEDSAF - tr.CALCULATEDFEE) >= 3016 then FAREDUE
        end) as FAREDUE
    FROM data tr
    left join emv.ETS_RAIL_APPORTIONMENT_MATRIX ram on (tr.ENTRYSTOPID = ram.ENTRYNLC and tr.EXITSTOPID = ram.EXITNLC)
    join emv.TAP tp on (tp.TAPID = tr.ENTRYTAPID)
    left join emv.ETS_OPERATOR opr on (opr.NLC = tr.ENTRYSTOPID)
    left join emv.ETS_BUS_ROUTE_VARIANT_V rvt on (tp.EMPLOYEEID = rvt.ETSBUSOPERATORID and tp.ROUTENUM = rvt.ROUTEVARIANT)
    left join emv.ETS_BUS_OPERATOR_DETAIL_V bso on (bso.ETSSUBSYSTEMID = rvt.ETSSUBSYSTEMID and bso.ETSBUSOPERATORID = rvt.ETSBUSOPERATORID)
    where tr.ENTRYTRANSACTIONDTM +11/24 < trunc(sysdate,'DD') + 1 -0 - (select * from dow) +4/24 -- adjust weekly barrier here
    and FAREDUE != 0
),
daily_total as (
    SELECT 
        tr.TRIPID,
        tr.ENTRYTRANSACTIONDTM +11/24 as day,
        tr.TOKENID, 
        tr.TRANSITACCOUNTID,
        (case when ram.apportionedoperatorid = '44' then '44 - Sydney Trains'
            when  ram.apportionedoperatorid = '45' then '45 - NSW Trainlink'
            when ram.apportionedoperatorid = '37' then '37 - Metro Trains Sydney'
            when opr.ETSOPERATORID = '1' then '1 - Sydney Ferries'
            when opr.ETSOPERATORID = '46' then '46 - Sydney Light Rail'
            when opr.ETSOPERATORID = '38' then '38 - Newcastle Transport'
            when rvt.ETSSUBSYSTEMID is not null then TO_CHAR(bso.ETSSUBSYSTEMID) || ' - ' || TO_CHAR(bso.ETSBUSOPERATORNAME)
            else 'No idea'
        end) as Apportioned_ETS_Operator,
        -- Check if SAF cap has reached, cap = $30.16 as of 2019Sep4
        (case when tr.ACCUMULATEDSAF < 3016 then FAREDUE - CALCULATEDFEE
            -- if SAF cap has just reached
            when  tr.ACCUMULATEDSAF >= 3016 and (tr.ACCUMULATEDSAF - tr.CALCULATEDFEE) < 3016 then FAREDUE - (3016 - (tr.ACCUMULATEDSAF - tr.CALCULATEDFEE))
            -- if SAF cap has reached prior
            when tr.ACCUMULATEDSAF >= 3016 and (tr.ACCUMULATEDSAF - tr.CALCULATEDFEE) >= 3016 then FAREDUE
        end) as FAREDUE
    FROM data tr
    left join emv.ETS_RAIL_APPORTIONMENT_MATRIX ram on (tr.ENTRYSTOPID = ram.ENTRYNLC and tr.EXITSTOPID = ram.EXITNLC)
    join emv.TAP tp on (tp.TAPID = tr.ENTRYTAPID)
    left join emv.ETS_OPERATOR opr on (opr.NLC = tr.ENTRYSTOPID)
    left join emv.ETS_BUS_ROUTE_VARIANT_V rvt on (tp.EMPLOYEEID = rvt.ETSBUSOPERATORID and tp.ROUTENUM = rvt.ROUTEVARIANT)
    left join emv.ETS_BUS_OPERATOR_DETAIL_V bso on (bso.ETSSUBSYSTEMID = rvt.ETSSUBSYSTEMID and bso.ETSBUSOPERATORID = rvt.ETSBUSOPERATORID)
    where FAREDUE != 0
), 
weekly_cumul as (
    select 
        TRIPID,
        StartDate,
        endDate,
        day,
        TOKENID,
        TRANSITACCOUNTID,
        apportioned_ets_operator,
        FAREDUE, 
        sum(FAREDUE) over (partition by TOKENID order by day, TOKENID) running_weekly_fare,
        sum(FAREDUE) over (partition by TOKENID) total_weekly_fare
    from weekly_total
    order by TOKENID, day desc
),
daily_cumul as (
    select 
        TRIPID,
        day,
        to_char(day-(4/24),'DAY', 'NLS_DATE_LANGUAGE=''numeric date language''') as business_day_of_the_week,
        TOKENID,
        TRANSITACCOUNTID,
        apportioned_ets_operator,
        FAREDUE,
        sum(FAREDUE) over (partition by trunc(day-4/24,'dd'), TOKENID order by day, TOKENID) running_daily_fare,
        sum(FAREDUE) over (partition by trunc(day-4/24,'dd'), TOKENID) total_daily_fare
    from daily_total 
),
daily_report_detailed as (
    -- if capping value changes, change all hardcoded values.
    -- current daily cap is $16.10
    -- current sunday cap is $2.80
    select 
        dc.*,
        (case 
            when business_day_of_the_week = 7 then
                (case
                    when running_daily_fare-280 >= FAREDUE then FAREDUE
                    when running_daily_fare-280 < 0 then 0
                    else running_daily_fare-280
                end)
            else 
                (case
                    when running_daily_fare-1610 >= FAREDUE then FAREDUE
                    when running_daily_fare-1610 < 0 then 0
                    else running_daily_fare-1610
                end)
        end
        ) as refund_amount
    from daily_cumul dc
    where day >= trunc(sysdate, 'dd')+4/24 - 1  and day < trunc(sysdate, 'dd')+4/24 - 0 -- date adjust here, -1, 0 is correct
    and FAREDUE != 0
    order by TOKENID, day desc
),

daily_report as (
-- daily detailed report aggregated
    select 
        --trunc(day,'dd')+4/24,
        TOKENID,
        TRANSITACCOUNTID,
        apportioned_ets_operator,
        sum(refund_amount) as refund
    from daily_report_detailed
    where refund_amount > 0
    group by trunc(day,'dd'), TRANSITACCOUNTID, TOKENID, apportioned_ets_operator
    order by TOKENID, TRANSITACCOUNTID
),
weekly_report_detailed as (
    -- current weekly cap is $50.00
    select 
        wc.*, 
        (case
            when running_weekly_fare-5000 >= FAREDUE then FAREDUE
            when running_weekly_fare-5000 < 0 then 0
            else running_weekly_fare-5000
        end) as refund_amount
    from weekly_cumul wc
    where FAREDUE != 0
    order by TOKENID
),
weekly_report as (
-- weekly detailed report aggregated
    select 
        TOKENID,
        TRANSITACCOUNTID,
        apportioned_ets_operator,
        sum(refund_amount) as refund
    from weekly_report_detailed
    where refund_amount > 0
    group by TRANSITACCOUNTID, TOKENID, apportioned_ets_operator
    order by TOKENID, TRANSITACCOUNTID
),
adjustments_detailed as (
    select
        JOURNALENTRYID,
        TRANSITACCOUNTID,
        regexp_substr(REFERENCEINFO, '[^-]+', 1, 1) as adjustment_Type,
        --regexp_substr(reference_info, '[^-]+$', 1, 1) as trip_id,  --replaced based on email from Michael (see line below)
        regexp_replace(regexp_substr(REFERENCEINFO, '[^-]+$', 1, 1),'\D', '') as TRIPID,
        TRANSACTIONDTM+11/24 as TRANSACTIONDTM,
        TRANSACTIONAMT,
        REFERENCEINFO
    from EMV.journal_entry
    where ((REFERENCEINFO like '%CapRefund%') OR (REFERENCEINFO like '%CapAdjustment%') OR (REFERENCEINFO like '%DenyListRefund%'))
    and (regexp_substr(REFERENCEINFO, '[^-]+$', 1, 1) ) not like '%Token%' 
    and JOURNALENTRYTYPEID = 102
    and TRANSACTIONDTM > (SELECT * FROM StartDate)+4/24 - 8 --date adjust here
    --and transaction_dtm < trunc(sysdate,'DD') + 1 - (select * from dow)+4/24 
),
adjustments as (
    select 
        TRIPID,
        sum(TRANSACTIONAMT) refunded
    from adjustments_detailed
    group by TRIPID
),
weekly_adjusted as (
    select 
        wrd.TRIPID,
        wrd.day,
        wrd.TOKENID,
        wrd.TRANSITACCOUNTID,
        wrd.apportioned_ets_operator,
        wrd.FAREDUE,
        wrd.refund_amount as weekly_refund_amount,
        --option A (we are using otion B for now - 20181217)
        /* 
        (case
            when ad.transaction_amt is null then 0
            else ad.transaction_amt
        end) as daily_refund_amount,
        (case
            when ad.transaction_amt is null then wrd.refund_amount
            when wrd.refund_amount-ad.transaction_amt < 0 then 0
            else wrd.refund_amount-ad.transaction_amt
        end) as final_refund_amount,
        */
        --option B
		(case
			when ad.TRANSACTIONAMT is null or ad.adjustment_type not like 'DailyCapRefund%' then 0
			else ad.TRANSACTIONAMT
		end) as daily_refund_amount,
        (case
            when ad.TRANSACTIONAMT is null then wrd.refund_amount
            when ad.adjustment_type like 'WeeklyCap%' then 0
            when wrd.refund_amount = 0 and ad.TRANSACTIONAMT != 0 then wrd.refund_amount-ad.TRANSACTIONAMT
            when wrd.refund_amount-ad.TRANSACTIONAMT < 0 then 0
            else wrd.refund_amount-ad.TRANSACTIONAMT
        end) as final_refund_amount,
        wrd.running_weekly_fare,
        wrd.total_weekly_fare,
        ad.JOURNALENTRYID as adjustment_journal_entry_id,
        ad.adjustment_type,
        ad.TRANSACTIONDTM,
        ad.REFERENCEINFO
    from weekly_report_detailed wrd
    left join adjustments_detailed ad
    on wrd.TRIPID = ad.TRIPID
    order by wrd.TOKENID, wrd.day desc
),
workaround_2 as (
    select 
        wa.TRIPID,
        wa.day,
        wa.TOKENID,
        wa.TRANSITACCOUNTID,
        wa.apportioned_ets_operator,
        wa.FAREDUE,
        wa.weekly_refund_amount,
        wa.daily_refund_amount,
        wa.final_refund_amount,
        /* replaced 20181217
		sum(wa.final_refund_amount) over (partition by trunc(day-4/24,'dd'), token_id order by day, token_id) running_final_refund_fare,
        sum(wa.final_refund_amount) over (partition by trunc(day-4/24,'dd'), token_id) total_final_refund_fare,
        */
		sum(wa.final_refund_amount) over (partition by wa.TOKENID order by day, wa.TOKENID) running_final_refund_fare,
        sum(wa.final_refund_amount) over (partition by wa.TOKENID) total_final_refund_fare,
		wa.adjustment_journal_entry_id,
        (select PGRETRIEVALREFNBR 
        from getRRN gr where wa.TRIPID = gr.TRIPID and rownum = 1) as RRN
    from weekly_adjusted wa
    --where wa.final_refund_amount > 0 --replaced 20181217
	where final_refund_amount != 0
    order by wa.TOKENID
),
workaround_3 as (
    select 
        drd.*,
        (select PGRETRIEVALREFNBR 
        from getRRN gr where drd.TRIPID = gr.TRIPID and rownum = 1) as RRN
    from daily_report_detailed drd
    where drd.refund_amount > 0
),
workaround_4 as (
    select
        dld.TOKENID,
        dld.TRANSITACCOUNTID,
        dld.PREV_TRANSACTIONDTM as "Tap On Time",
        tap.TRIPID,
        dld.apportioned_ETS_Operator,
        dld.DEFAULTFARE,
        dld.FAREDUE,
        (select PGRETRIEVALREFNBR 
        from getRRN gr where tap.TRIPID = gr.TRIPID and rownum = 1) as RRN
    from deny_list_detailed dld
    left join EMV.TAP
    on tap.TAPID = dld.PREV_TAPID
    where dld.DEFAULTFARE = 1
)
-- weekly cap
--select * from workaround_2 where total_final_refund_fare > 0 and running_final_refund_fare > 0 --updated 20181217
-- daily cap
--select * from workaround_3 
-- deny list 
--select * from workaround_4
--confirm adjustment
--select * from adjustments_detailed ad
--where ad.transaction_dtm > trunc(sysdate)
--order by transaction_dtm desc
;