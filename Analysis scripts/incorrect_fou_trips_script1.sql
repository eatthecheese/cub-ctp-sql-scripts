/* 1. The query for Scenario 1 looks for any transit accounts where the count of Journey is different to what is the Capping XML (This runs on ABP database)

Please note: This query will also pick up records that has FOU greater than 8 since the Capping XML does not increment past 8. 
Therefore it is difficult to provide a accurate list of accounts impacted. 
The data can be filtered to remove any that has FOU less than 8 which will show all the transit account where there is a jump in sequence. 
*/
--Check FOU count+
alter session set current_schema = abp_main;

with tr_count as (select count(distinct (JOURNEY_ID)) as trip_count, tr.TOKEN_ID
from TRIP tr where ENTRY_TRANSACTION_DTM + 10/24    between TO_TIMESTAMP('2019-09-09 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') and TO_TIMESTAMP('2019-09-16 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')  and tr.MISSING_TAP_FLAG = '0' group by tr.TOKEN_ID)
select
cap.TRANSIT_ACCOUNT_ID,
       cap.TOKEN_ID,
       tr_count.trip_count,
XMLQUERY('/PriceCapTotals/Combined/int[1]/text()' passing xmltype(cap.TOTALS) RETURNING CONTENT).getStringVal() as weekly,
XMLQUERY('/PriceCapTotals/Combined/int[2]/text()' passing xmltype(cap.TOTALS) RETURNING CONTENT).getStringVal() as sunday,
XMLQUERY('/PriceCapTotals/Combined/int[3]/text()' passing xmltype(cap.TOTALS) RETURNING CONTENT).getStringVal() as daily,
XMLQUERY('/PriceCapTotals/Combined/int[4]/text()' passing xmltype(cap.TOTALS) RETURNING CONTENT).getStringVal() as fou,
XMLQUERY('/PriceCapTotals/Combined/int[5]/text()' passing xmltype(cap.TOTALS) RETURNING CONTENT).getStringVal() as saf,
XMLQUERY('/PriceCapTotals/FOUPrevJourneyId/string[4]/text()' passing xmltype(cap.TOTALS) RETURNING CONTENT).getStringVal() as fou_last_trip
from ABP_MAIN.CAPPING cap join tr_count on cap.TOKEN_ID = tr_count.TOKEN_ID where tr_count.trip_count < XMLQUERY('/PriceCapTotals/Combined/int[4]/text()' passing xmltype(cap.TOTALS) RETURNING CONTENT).getStringVal()
and cap.updated_dtm + 10/24 < TO_TIMESTAMP('2019-09-16 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
and tr_count.trip_count > 0;