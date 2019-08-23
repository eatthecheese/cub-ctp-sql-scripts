/* Define the summary period date for which you would like data for
*/
define l_testDate = TO_DATE('30/JUL/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
define l_timezoneModifier = 10;

WITH ALL_AIRPORT_TRIPS as (
    SELECT  
        NVL(TR.JOURNEY_ID,-1) JOURNEY_ID,
        TR.TOKEN_ID,
        tax.TRANSIT_ACCOUNT_ID,
        TR.SEGMENT_ID,
        to_char((TR.entry_transaction_dtm+&l_timezoneModifier/24),'YYYY-MM-DD') as TapDate,
        min(TR.TRANSFER_SEQUENCE_NBR) as Origin,
        max(TR.TRANSFER_SEQUENCE_NBR) as Destination
    FROM abp_main.TRIP TR
        LEFT JOIN abp_main.LOCALE EntryLoc ON TR.ENTRY_STOP_ID = EntryLoc.LOCALE_ID
        LEFT JOIN abp_main.LOCALE ExitLoc ON TR.EXIT_STOP_ID = ExitLoc.LOCALE_ID
        LEFT JOIN abp_main.transit_account_x_token tax on tax.token_id = tr.token_id
    WHERE (EntryLoc.LOCALE_ID in ('281','228', '258', '361') or ExitLoc.LOCALE_ID in ('281','228', '258', '361')) -- LocalIDs for International and Domestic
        and TR.JOURNEY_ID <> -1                                                                              
        and (TR.entry_transaction_dtm+&l_timezoneModifier/24) between &l_testDate + 4/24 and &l_testDate + 6 + 4/24 -- Take the summary period as defined by TestDate
    group by NVL(TR.JOURNEY_ID,-1),
    TR.SEGMENT_ID,
    TR.TOKEN_ID,
    tax.TRANSIT_ACCOUNT_ID,
    to_char((TR.entry_transaction_dtm + &l_timezoneModifier/24),'YYYY-MM-DD')
    having count(TR.trip_id)>1
)
SELECT 
    J.TOKEN_ID,
    J.TRANSIT_ACCOUNT_ID,
    J.TapDate,
    to_char(((TR1.entry_transaction_dtm+&l_timezoneModifier/24)),'YYYY-MM-DD HH24:MI:SS') TapOnTimeStamp,
    to_char(((TR2.exit_transaction_dtm+&l_timezoneModifier/24)),'YYYY-MM-DD HH24:MI:SS') TapoffTimeStamp,
    EntryLoc1.Description as Entry,
    ExitLoc1.Description as Exit,
    MAX(CASE WHEN EntryLoc1.LOCALE_ID not in ('281','228','258','361') and ExitLoc1.LOCALE_ID in ('228','281')  then 1487 -- NON-ALC to Domestic or International
        WHEN  EntryLoc1.LOCALE_ID in ('228','281') and ExitLoc1.LOCALE_ID not in ('281','228','258','361') then 1487 --International or domestic to NON-ALC
        WHEN EntryLoc1.LOCALE_ID in ('281','228') and ExitLoc1.LOCALE_ID in ('228','281')  then 220 --International or Domestic to International or Domestic
        WHEN EntryLoc1.LOCALE_ID in ('361') and ExitLoc1.LOCALE_ID in ('228','281')  then 657 --Mascot to International or Domestic
        WHEN EntryLoc1.LOCALE_ID in  ('228','281') and ExitLoc1.LOCALE_ID in ('361')  then 657  --International or Domestic to Mascot
        WHEN EntryLoc1.LOCALE_ID in ('258') and ExitLoc1.LOCALE_ID in ('228','281')  then 897 --Green Square to International or Domestic
        WHEN EntryLoc1.LOCALE_ID in  ('228','281') and ExitLoc1.LOCALE_ID in ('258')  then 897 --International or Domestic to Green Square
        else 0 end) as "Expected SAF paid",   
        SUM(TR3.Calculated_fee) as "Actual SAF paid",
        (SUM(TR3.Calculated_fee) - 
        MAX(CASE WHEN EntryLoc1.LOCALE_ID not in ('281','228','258','361') and ExitLoc1.LOCALE_ID in ('228','281')  then 1487 -- NON-ALC to Domestic or International
        WHEN  EntryLoc1.LOCALE_ID in ('228','281') and ExitLoc1.LOCALE_ID not in ('281','228','258','361') then 1487 --International or domestic to NON-ALC
        WHEN EntryLoc1.LOCALE_ID in ('281','228') and ExitLoc1.LOCALE_ID in ('228','281')  then 220 --International or Domestic to International or Domestic
        WHEN EntryLoc1.LOCALE_ID in ('361') and ExitLoc1.LOCALE_ID in ('228','281')  then 657 --Mascot to International or Domestic
        WHEN EntryLoc1.LOCALE_ID in  ('228','281') and ExitLoc1.LOCALE_ID in ('361')  then 657  --International or Domestic to Mascot
        WHEN EntryLoc1.LOCALE_ID in ('258') and ExitLoc1.LOCALE_ID in ('228','281')  then 897 --Green Square to International or Domestic
        WHEN EntryLoc1.LOCALE_ID in  ('228','281') and ExitLoc1.LOCALE_ID in ('258')  then 897 --International or Domestic to Green Square
    else 0 end)  
     ) as refund_amt,
    count(distinct TR3.TRANSFER_SEQUENCE_NBR) as "Nbr of Jny segments", -- Total trips in that Journey ID for that Token on that day.
    TR1.TRANSFER_SEQUENCE_NBR as OriginTSN, -- First sequence for airport trip
    TR2.TRANSFER_SEQUENCE_NBR as DestinationTSN --Last sequence for airport trip
from ALL_AIRPORT_TRIPS J --Start and end of the airport part of the journey segment
    LEFT JOIN abp_main.TRIP TR1 on J.TOKEN_ID = TR1.TOKEN_ID 
            and J.SEGMENT_ID = TR1.SEGMENT_ID 
            and J.TapDate = to_char(((TR1.entry_transaction_dtm+&l_timezoneModifier/24)),'YYYY-MM-DD') 
            and J.JOURNEY_ID = TR1.JOURNEY_ID 
            AND J.Origin= TR1.TRANSFER_SEQUENCE_NBR 
    LEFT JOIN  abp_main.TRIP TR2 on J.TOKEN_ID = TR2.TOKEN_ID  and J.SEGMENT_ID = TR2.SEGMENT_ID and J.TapDate = to_char(((TR2.entry_transaction_dtm+&l_timezoneModifier/24)),'YYYY-MM-DD') and J.JOURNEY_ID = TR2.JOURNEY_ID and J.destination = TR2.TRANSFER_SEQUENCE_NBR
    LEFT JOIN  abp_main.TRIP TR3 on J.TOKEN_ID = TR3.TOKEN_ID  and J.SEGMENT_ID = TR3.SEGMENT_ID and J.TapDate = to_char(((TR3.entry_transaction_dtm+&l_timezoneModifier/24)),'YYYY-MM-DD') and J.JOURNEY_ID = TR3.JOURNEY_ID
    LEFT JOIN abp_main.LOCALE EntryLoc1 ON TR1.ENTRY_STOP_ID = EntryLoc1.LOCALE_ID
    LEFT JOIN abp_main.LOCALE ExitLoc1 ON TR2.EXIT_STOP_ID = ExitLoc1.LOCALE_ID
group by 
    J.TOKEN_ID,
    J.TRANSIT_ACCOUNT_ID,
    J.JOURNEY_ID,
    J.SEGMENT_ID,
    J.TapDate,
    to_char(((TR1.entry_transaction_dtm+&l_timezoneModifier/24)),'YYYY-MM-DD HH24:MI:SS') ,
    to_char(((TR2.exit_transaction_dtm+&l_timezoneModifier/24)),'YYYY-MM-DD HH24:MI:SS') ,
    EntryLoc1.Description ,
    ExitLoc1.Description,
    TR1.TRANSFER_SEQUENCE_NBR,
    TR2.TRANSFER_SEQUENCE_NBR
order by to_char(((TR1.entry_transaction_dtm+&l_timezoneModifier/24)),'YYYY-MM-DD HH24:MI:SS') desc
;