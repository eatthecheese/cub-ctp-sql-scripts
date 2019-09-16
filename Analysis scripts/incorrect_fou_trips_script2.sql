/* 2. The query looks for any journeys that didnt have FOU discount after the count is greater than 8
*/
/* ### Change the time band accordingly before use! lines 8, 18 and 36*/
WITH TRIPS_GT_EIGHTJNYS as (
    select count (distinct tr.journeyid) as FOUCOUNT, tr.tokenid, tr.transitaccountid
 from emv.trip tr
    where
 tr.ENTRYTRANSACTIONDTM + 10/24 between TO_TIMESTAMP('2019-09-09 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') and TO_TIMESTAMP('2019-09-16 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
    and tr.MISSINGTAPFLAG = 0
 and tr.CALCULATEDFARE != tr.CAPAMT
 group by tr.tokenid, tr.transitaccountid
 having count(distinct tr.journeyid) > 8
),
ACCOUNTS_W_FOUDCNT as (
    select count (je.journalentryid) as FOUDISCOUNTRECORDS, je.transitaccountid
 from emv.journal_entry je
    where
 je.TRANSACTIONDTM + 10/24 between TO_TIMESTAMP('2019-09-09 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') and TO_TIMESTAMP('2019-09-16 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
    and je.CAPPINGSCHEMEDESCRIPTION = 'Frequency of Use Discount'
 group by je.transitaccountid
),
ACCOUNTS_WO_FOUDCNT as (
    select tre.TRANSITACCOUNTID, tre.TOKENID, tre.FOUCOUNT, awfou.FOUDISCOUNTRECORDS
    from TRIPS_GT_EIGHTJNYS tre
    left join ACCOUNTS_W_FOUDCNT awfou on tre.TRANSITACCOUNTID = awfou.TRANSITACCOUNTID
 where awfou.FOUDISCOUNTRECORDS is null
),
FOU_JOURNEYS as (
    SELECT distinct NVL(TR.JOURNEYID, -1) JOURNEYID,
           TR.TOKENID,
           count(tr.JOURNEYID_DISTINCT) over (partition by tr.TOKENID order by tr.ENTRYTRANSACTIONDTM) as FOUCOUNT
    from 
    (select tr.JOURNEYID, tr.TOKENID, tr.ENTRYTRANSACTIONDTM, 
    -- only get distinct journeyid's by looking at only the first instance of a journeyid
    CASE WHEN row_number() OVER (PARTITION BY tr.TOKENID, tr.JOURNEYID ORDER BY tr.JOURNEYID) = 1 THEN tr.JOURNEYID ELSE null END JOURNEYID_DISTINCT
    from EMV.TRIP tr
    ) tr
    inner join ACCOUNTS_WO_FOUDCNT awod on awod.TOKENID = tr.TOKENID
 WHERE TR.JOURNEYID <> -1
 and
 tr.ENTRYTRANSACTIONDTM + 10/24 between TO_TIMESTAMP('2019-09-09 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') and TO_TIMESTAMP('2019-09-16 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
)
select tr.TRIPID, tr.TRANSITACCOUNTID, tr.TOKENID, tr.ENTRYTRANSACTIONDTM + 10/24 as ENTRY_DTM, tr.EXITTRANSACTIONDTM + 10/24,
tr.JOURNEYID, tr.CALCULATEDFARE, tr.CALCULATEDFEE, tr.FAREDUE, fouj.FOUCOUNT, FLOOR((tr.FAREDUE - tr.CALCULATEDFEE)/2) as EXPECTED_FAREDUE, CEIL((tr.FAREDUE - tr.CALCULATEDFEE)/2) as REFUNDAMT
from emv.TRIP tr
inner join FOU_JOURNEYS fouj on tr.JOURNEYID = fouj.JOURNEYID
where fouj.FOUCOUNT > 8;