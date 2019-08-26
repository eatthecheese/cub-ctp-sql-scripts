/* Look up Tap history for a transit account like the GUI
*/
define l_timezoneModifier = 10;
define l_testTransitAccountID = 100008892471;

desc abp_main.tap;

select tp.UNMATCHED_FLAG, tp.TAP_ID, tp.TRANSIT_ACCOUNT_ID, tp.TOKEN_ID
from abp_main.tap tp
where  tp.TAP_ID in (
16771017,
16780178,
16784781,
16785345,
16787501,
16790738,
16793118,
16795397
)
;

select tp.TAP_ID, tp.DEVICE_ID, tp.TRANSIT_ACCOUNT_ID, tp.TOKEN_ID, tp.TRANSACTION_DTM + &l_timezoneModifier/24,  
loc.DESCRIPTION, 
case 
    when tp.ENTRY_EXIT_ID = '11' then 'EntryOrExit'
    when tp.ENTRY_EXIT_ID = '13' then 'Exit'
    when tp.ENTRY_EXIT_ID = '12' then 'Entry'
    else 'Unknown Type'
end
AS "Type",
tpstat.DESCRIPTION, 
case
    when tp.UNMATCHED_FLAG = '3' then 'Matched'
    when tp.UNMATCHED_FLAG = '1' then 'Ignored'
    when tp.UNMATCHED_FLAG = '5' then 'Void'
    else 'Unknown if Matched/Unmatched'
end
AS "Matched Flag",
tp.TRIP_ID, tp.INSERTED_DTM + &l_timezoneModifier/24, tp.UPDATED_DTM + &l_timezoneModifier/24,
tp.BIN, tp.NEG_LIST_AS_OF_DTM + &l_timezoneModifier/24, tp.NEG_LIST_CURRENT_VERSION
from abp_main.tap tp
left join abp_main.tap_status tpstat
on tp.TAP_STATUS_ID = tpstat.TAP_STATUS_ID
left join abp_main.locale loc
on tp.STOP_ID = loc.LOCALE_ID
where tp.TRANSIT_ACCOUNT_ID = &l_testTransitAccountID
and tp.TRANSACTION_DTM+10/24 between TO_DATE('16/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') and
TO_DATE('17/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS')
order by tp.TRANSACTION_DTM desc
;

select count(tp.tap_id)
from abp_main.tap tp
where tp.TRANSACTION_DTM between TO_DATE('16/AUG/2019 07:00:00', 'DD/MM/YYYY HH24:MI:SS') and
TO_DATE('16/AUG/2019 14:00:00', 'DD/MM/YYYY HH24:MI:SS') 
;

SELECT
  TAPID,
  DEVICEID,
  TRANSACTIONID,
  EMV.CTS_UTILS_01.local_dtm(TRANSACTIONDTM) TRANSACTIONDTM,
  SEQUENCE,
  TAP.TOKENID,
  LOCALE.DESCRIPTION STOP,
  case when ENTRYEXITID = 11 then 'EntryOrExit'
       when ENTRYEXITID = 12 then 'Entry'
       when ENTRYEXITID = 13 then 'Exit'
       when ENTRYEXITID = 14 then 'Inspection'
                             else 'Other' end ENTRYEXIT,
  case when TAPTYPEID = 1 then 'Tap'
       when TAPTYPEID = 2 then 'Missing Tap'
       when TAPTYPEID = 3 then 'Reserved'
       when TAPTYPEID = 4 then 'MissingTapForcedEntry'
       when TAPTYPEID = 5 then 'MissingTapForcedExit'
                          else 'Other' end TAPPTYPE,
  case when UNMATCHEDFLAG =  1 then 'Ignored'
       when UNMATCHEDFLAG =  2 then 'Unmatched'
       when UNMATCHEDFLAG =  3 then 'Matched'
       when UNMATCHEDFLAG =  4 then 'PendingVoid '
       when UNMATCHEDFLAG =  5 then 'Void'
       when UNMATCHEDFLAG =  6 then 'PendingJourneyExtension'
                               else 'Other' end UNMATCHEDFLAG,
  TAPSTATUSDESCRIPTION,
  TAP.TRANSITACCOUNTID,
  BANKCARD.Bin||'-'||substr(BANKCARD.CardPartial,2,3) CARDNUMBER,
  op.operatorname OPERATOR,
  op.etsoperatorid OPERATOR_ID

FROM EMV.TAP INNER JOIN EMV.TAP_STATUS on TAP.TAPSTATUSID = TAP_STATUS.TAPSTATUSID
         INNER JOIN EMV.LOCALE ON TAP.STOPID = LOCALE.LOCALEID
         INNER JOIN EMV.TOKEN on TAP.TOKENID = TOKEN.TOKENID
         INNER JOIN EMV.BANKCARD on TOKEN.BANKCARDID = BANKCARD.BANKCARDID
         LEFT JOIN EMV.ets_operator op               on TAP.STOPID = op.NLC
WHERE TRIPID IS NULL
  AND TAP_STATUS.GOODFLAG = 1
  AND trunc(EMVINSERTEDDTM - 4/24) >= trunc(sysdate-5)
  AND trunc(EMVINSERTEDDTM - 4/24) < trunc(sysdate-4)
;

select * from abp_main.sys_info;

desc abp_main.sys_info;

select count(*), fr.JOB_ID, fr.EFFECTIVE_DTM, fr.IS_VALID_FLAG
from abp_main.fare_rule_in_use fr
where fr.EFFECTIVE_DTM > TO_DATE('24/JUL/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') 
group by fr.JOB_ID, fr.EFFECTIVE_DTM, fr.IS_VALID_FLAG
order by fr.EFFECTIVE_DTM
;

select * from abp_main.fare_rule where job_id = '361';

select * from abp_main.fare_rule_in_use where job_id = '381';

select count(*)
from abp_main.fare_rule_x_conc_level_in_use fr
;

select count(*), fr.JOB_ID, fr.EFFECTIVE_DTM, fr.IS_VALID_FLAG
from abp_main.fare_rule_in_use fr
--where fr.EFFECTIVE_DTM > TO_DATE('01/MAY/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') 
group by fr.JOB_ID, fr.EFFECTIVE_DTM, fr.IS_VALID_FLAG
;

select * from abp_main.trip where trip_id = '515393';

select * from abp_main.fare_rule_x_conc_level_in_use where fare_rule_id = '1206638';

select * from abp_main.fare_rule_in_use where ENTRY_LOCALE_ID = '191' and EXIT_LOCALE_ID = '407';
select * from abp_main.fare_rule_x_conc_level_in_use where FARE_RULE_ID = '1109017';

-- Both Views must be refreshed
--BEGIN DBMS_SNAPSHOT.REFRESH( '"ABP_MAIN"."FARE_RULE_IN_USE"'); end;
--BEGIN DBMS_SNAPSHOT.REFRESH('"ABP_MAIN"."FARE_RULE_X_CONC_LEVEL_IN_USE"'); end;

select * from abp_main.sys_info;

update ABP_MAIN.SYS_INFO
set MAX_FARE_RULE_EFFECTIVE_DTM = TO_TIMESTAMP('2019-08-23 11:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') -10/24
;

SELECT /*+ index(TAP IN1_TAP)*/ sys_extract_utc(systimestamp) - INSERTED_DTM AS DEPTH,
                                tap.TAP_ID, tap.TRANSACTION_DTM + 10/24, tap.TOKEN_ID, tap.TRANSIT_ACCOUNT_ID
FROM abp_main.tap
WHERE UNMATCHED_FLAG = '2'
ORDER BY sys_extract_utc(systimestamp) - INSERTED_DTM DESC;

desc abp_main.trip;

select VOID_TYPE, VOID_FLAG
from abp_main.trip where rownum < 100;