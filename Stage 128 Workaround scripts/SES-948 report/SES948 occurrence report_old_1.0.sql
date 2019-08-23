/* Define the summary period date for which you would like data for
*/
define l_testDate = TO_DATE('29/JUL/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
define l_timezoneModifier = 10;
define l_ferryAdultFB2Fare = 765;

WITH MANLY_TRIPS_COMPLETE as 
(SELECT 
        NVL(TR.JOURNEY_ID, -1) JOURNEY_ID, -- IF JOURNEY_ID = null, make = -1 to determine if it was a valid Trip
        tr.TRIP_ID,
        tr.TOKEN_ID,
        tr.TRANSIT_ACCOUNT_ID,
        tr.TRANSFER_SEQUENCE_NBR,
        tr.SEGMENT_ID,
        tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24 as "Entry Tap time",
        tr.ENTRY_STOP_ID,
        tr.EXIT_STOP_ID
    FROM ABP_MAIN.TRIP tr
    WHERE         
        (tr.ENTRY_STOP_ID in ('936', '939') or tr.EXIT_STOP_ID in ('936', '939'))
        and tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24  between &l_testDate + 4/24 and &l_testDate + 1 + 4/24
        and tr.JOURNEY_ID <> -1
),
MANLY_JOURNEYS_COMPLETE as
(select tr.JOURNEY_ID,
        tr.TRIP_ID,
        tr.TOKEN_ID,
        tr.SEGMENT_ID,
        tr.TRANSIT_ACCOUNT_ID,
        tr.TRANSFER_SEQUENCE_NBR,
        tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24 as ENTRY_DTM_AEST,
        tr.FARE_DUE,
        tr.ENTRY_STOP_ID,
        tr.EXIT_STOP_ID
from ABP_MAIN.TRIP tr, MANLY_TRIPS_COMPLETE mtc
where 
    tr.JOURNEY_ID = mtc.JOURNEY_ID -- All Trips in the same Journey
    and tr.SEGMENT_ID = mtc.SEGMENT_ID -- All Trips in the same Segment (i.e. Intramodal chain)
    and tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24  between &l_testDate + 4/24 and &l_testDate + 1 + 4/24
),
DISTINCT_MANLY_JOURNEYS as
(select DISTINCT (TRIP_ID)
from MANLY_JOURNEYS_COMPLETE
),
DISTINCT_MANLY_JOURNEYS_COM as 
(select tr.JOURNEY_ID,
        tr.TRIP_ID,
        tr.TOKEN_ID,
        tr.SEGMENT_ID,
        tr.TRANSIT_ACCOUNT_ID,
        tr.TRANSFER_SEQUENCE_NBR,
        tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24 as ENTRY_DTM_AEST,
        tr.FARE_DUE,
        tr.ENTRY_STOP_ID,
        tr.EXIT_STOP_ID
from ABP_MAIN.TRIP tr
join DISTINCT_MANLY_JOURNEYS dmj
ON tr.TRIP_ID = dmj.TRIP_ID
),
MANLY_JOURNEY_TSNS as 
(select 
    dmjc.JOURNEY_ID,
    dmjc.SEGMENT_ID,
    sum(FARE_DUE) as SEGMENT_FARE_DUE,
    MAX (dmjc.TRANSFER_SEQUENCE_NBR) as MAX_TSN, -- GET THE TSN OF THE FINAL TRIP IN THE SEGMENT
    MIN (dmjc.TRANSFER_SEQUENCE_NBR) as MIN_TSN -- GET THE TSN OF THE FIRST TRIP IN THE SEGMENT
FROM DISTINCT_MANLY_JOURNEYS_COM dmjc
GROUP BY
    dmjc.JOURNEY_ID,
    dmjc.SEGMENT_ID
),
MANLY_SEGMENTS_COMPLETE as
(select mjt.JOURNEY_ID,
    tr_start.TOKEN_ID,
    tr_start.TRANSIT_ACCOUNT_ID,
    tr_final.TRANSFER_SEQUENCE_NBR + 1 as NUM_TRIP_LEGS,
    tr_start.TRIP_ID as ORIGIN_TRIP_ID,
    loc_entry.DESCRIPTION as ORIG_WHARF,
    tr_start.ENTRY_STOP_ID,
    tr_final.TRIP_ID as DEST_TRIP_ID,
    loc_exit.DESCRIPTION as DEST_WHARF,
    tr_final.EXIT_STOP_ID,
    tr_start.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24 as ORIG_ENTRY_DTM,
    tr_final.EXIT_TRANSACTION_DTM + &l_timezoneModifier/24 as DEST_EXIT_DTM,
    mjt.SEGMENT_FARE_DUE as FARE_ACTUAL,
    &l_ferryAdultFB2Fare as FARE_EXPECTED,
    (&l_ferryAdultFB2Fare - mjt.SEGMENT_FARE_DUE) as UNDERCHARGE_AMT
from MANLY_JOURNEY_TSNS mjt
join ABP_MAIN.TRIP tr_final -- Get the final Trip in the Segment
    on mjt.JOURNEY_ID = tr_final.JOURNEY_ID
    and mjt.SEGMENT_ID = tr_final.SEGMENT_ID
    and mjt.MAX_TSN = tr_final.TRANSFER_SEQUENCE_NBR
join ABP_MAIN.TRIP tr_start -- Get the starting Trip in the Segment    
    on mjt.JOURNEY_ID = tr_start.JOURNEY_ID
    and mjt.SEGMENT_ID = tr_start.SEGMENT_ID
    and mjt.MIN_TSN = tr_start.TRANSFER_SEQUENCE_NBR
left join ABP_MAIN.LOCALE loc_entry
    on loc_entry.SYSTEM_ID = tr_start.ENTRY_STOP_ID -- Get the Origin wharf name
left join ABP_MAIN.LOCALE loc_exit
    on loc_exit.SYSTEM_ID = tr_final.EXIT_STOP_ID -- Get the Destination wharf name
)
select *
FROM MANLY_SEGMENTS_COMPLETE
where NUM_TRIP_LEGS <> 1
order by JOURNEY_ID desc
;