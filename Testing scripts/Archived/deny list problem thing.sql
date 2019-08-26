select *
from ABP_MAIN.JOURNAL_ENTRY a
join ABP_MAIN.JOURNAL_ENTRY b
on 
;

with StartDate as (
    select 
        TO_DATE('03/DEC/2018 00:00:00') testDate
    from dual
), MidDate as (
    select 
        TO_DATE('04/DEC/2018 00:00:00') otherdate
    from dual
),EndDate as (
    select 
        TO_DATE('05/DEC/2018 00:00:00') otherdate
    from dual
), UncollectibleTrips as (
    select * 
    from ABP_MAIN.JOURNAL_ENTRY
    where JOURNAL_ENTRY_TYPE_ID = 108
    and TRANSACTION_DTM + 11/24 >= (SELECT * FROM StartDate) +4/24
    and TRANSACTION_DTM + 11/24 <= (SELECT * FROM EndDate) +4/24
), UncollectibleTripsTripIds as (
    select a.trip_id
    from UncollectibleTrips a
    order by bankcard_payment_id
), ManualAdjustmentEntries as (
    select * 
    from ABP_MAIN.JOURNAL_ENTRY
    where JOURNAL_ENTRY_TYPE_ID = 102
    and TRANSACTION_DTM + 11/24 >= (SELECT * FROM MidDate) +4/24
    and TRANSACTION_DTM + 11/24 <= (SELECT * FROM EndDate) +4/24
)
select a.*
from ManualAdjustmentEntries a
join UncollectibleTripsTripIds b
on a.REFERENCE_INFO like concat(concat('''%',b.trip_id),'%''')
--on a.REFERENCE_INFO like '%386604%'
;