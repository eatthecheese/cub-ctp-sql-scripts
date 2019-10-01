-- Check for any Trips where ABP has processed as "Peak"
-- Returns all Trips with PEAK_OFFPEAK_ID != Offpeak.
select tr.trip_id, tr.ENTRY_TRANSACTION_DTM + 10/24 as ENTRY_TAP_DTM, tr.EXIT_TRANSACTION_DTM + 10/24 as EXIT_TAP_DTM, 
(case when tr.PEAK_OFFPEAK_ID = '1' then 'Offpeak'
else 'Peak' end) as PEAKOFFPEAK,
tr.FARE_DUE, tr.CALCULATED_FARE, tr.TRANSIT_ACCOUNT_ID,
tr.INITIAL_PRICING_DTM + 10/24, tr.INITIAL_COLLECTION_DTM + 10/24
from abp_main.trip tr
where 
-- Only look for trips with non-offpeak pricing, i.e. peak
tr.PEAK_OFFPEAK_ID <> '1'
and tr.ENTRY_TRANSACTION_DTM + 10/24 between
-- Define time band here
TO_TIMESTAMP('2019-10-07 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') and
TO_TIMESTAMP('2019-10-08 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
-- Only look for Rail trips
and tr.ENTRY_OPERATOR_ID = '1000'
-- Only care about non-zero fare trips
and tr.FARE_DUE - tr.CALCULATED_FEE > 0
order by tr.INITIAL_COLLECTION_DTM desc
;