select *
from abp_main.trip tr
where tr.TRIP_ID = '1000';

desc trip;

select *
from abp_main.locale loc
where loc.SYSTEM_ID = '945'
;

with fare_rule_w_fare as (
select fr.fare_rule_id, fr.entry_locale_id, fr.peak_offpeak_id, fr.exit_locale_id, frx.fare_amt, fr.EFFECTIVE_DTM
from abp_main.fare_rule fr
left join abp_main.fare_rule_x_conc_level frx ON fr.FARE_RULE_ID = frx.FARE_RULE_ID
where fr.EFFECTIVE_DTM > TO_TIMESTAMP('2019-06-01 18:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
)
select tr.TRIP_ID, tr.INSERTED_DTM + 10/24,tr.ENTRY_STOP_ID as TRIP_ENTRY, tr.EXIT_STOP_ID as TRIP_EXIT, tr.FARE_RULE_ID as ACTUAL_FARE_RULE_ID, fr.ENTRY_LOCALE_ID as ACTUAL_FR_ENTRY, fr.EXIT_LOCALE_ID as ACTUAL_FR_EXIT,
tr.calculated_fare as ACTUAL_FARE,  frwf.FARE_RULE_ID as EXPECTED_FARE_RULE_ID, frwf.ENTRY_LOCALE_ID as EXP_FR_ENTRY, frwf.EXIT_LOCALE_ID as EXP_FR_EXIT, frwf.fare_amt as EXPECTED_FARE, 
fr.EFFECTIVE_DTM + 10/24,frwf.EFFECTIVE_DTM+10/24
from abp_main.TRIP tr
       JOIN FARE_RULE_W_FARE frwf ON (tr.ENTRY_STOP_ID = frwf.ENTRY_LOCALE_ID and tr.EXIT_STOP_ID = frwf.EXIT_LOCALE_ID and tr.PEAK_OFFPEAK_ID = frwf.PEAK_OFFPEAK_ID)
       LEFT JOIN ABP_MAIN.FARE_RULE fr ON (tr.FARE_RULE_ID = fr.FARE_RULE_ID)
where tr.INSERTED_DTM + 10/24 > TO_TIMESTAMP('2019-08-03 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') and (tr.ENTRY_STOP_ID <> fr.ENTRY_LOCALE_ID or tr.EXIT_STOP_ID <> fr.EXIT_LOCALE_ID)
and tr.transfer_flag = 1
order by tr.INSERTED_DTM + 10/24 desc;

with fare_rule_w_fare as (
select fr.fare_rule_id, fr.entry_locale_id, fr.peak_offpeak_id, fr.exit_locale_id, frx.fare_amt, fr.EFFECTIVE_DTM
from abp_main.fare_rule fr
left join abp_main.fare_rule_x_conc_level frx ON fr.FARE_RULE_ID = frx.FARE_RULE_ID
where fr.EFFECTIVE_DTM > TO_TIMESTAMP('2019-07-23 18:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
)
select tr.TRIP_ID, tr.INSERTED_DTM + 10/24,tr.ENTRY_STOP_ID as TRIP_ENTRY, tr.EXIT_STOP_ID as TRIP_EXIT, tr.FARE_RULE_ID as ACTUAL_FARE_RULE_ID, 
tr.calculated_fare as ACTUAL_FARE,  frwf.FARE_RULE_ID as EXPECTED_FARE_RULE_ID, frwf.ENTRY_LOCALE_ID as EXP_FR_ENTRY, frwf.EXIT_LOCALE_ID as EXP_FR_EXIT, frwf.fare_amt as EXPECTED_FARE, 
frwf.EFFECTIVE_DTM+10/24
from abp_main.TRIP tr
       JOIN FARE_RULE_W_FARE frwf ON (tr.FARE_RULE_ID = frwf.FARE_RULE_ID)
where tr.INSERTED_DTM + 10/24 > TO_TIMESTAMP('2019-08-02 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') and (tr.calculated_fare <> frwf.fare_amt)
and tr.transfer_flag = 1
and tr.DEFAULT_FARE_FLAG = 0
order by tr.INSERTED_DTM + 10/24 desc;

with EFFECTIVE_FARES as (
select *
from abp_main.fare_rule_in_use
where EFFECTIVE_DTM + 10/24 >= TO_TIMESTAMP('2019-08-01 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
)
select tr.*
from abp_main.trip tr
JOIN EFFECTIVE_FARES fr ON (tr.FARE_RULE_ID = fr.FARE_RULE_ID)
where tr.INSERTED_DTM + 10/24 between TO_TIMESTAMP('2019-08-02 16:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') and TO_TIMESTAMP('2019-08-02 17:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
--and fr.EFFECTIVE_DTM + 10/24 >= TO_TIMESTAMP('2019-08-01 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
--and tr.transfer_flag = 1
;

select *
from abp_main.fare_rule_in_use
where EFFECTIVE_DTM + 10/24 >= TO_TIMESTAMP('2019-08-01 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
and ENTRY_LOCALE_ID = 100 and EXIT_LOCALE_ID = 101;

select *
from abp_main.trip tr
where tr.ENTRY_STOP_ID = '101'
and tr.EXIT_STOP_ID in ('372')
and tr.INSERTED_DTM + 10/24 between TO_TIMESTAMP('2019-08-02 16:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') and TO_TIMESTAMP('2019-08-02 17:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
;


desc abp_main.fare_rule_in_use;
desc abp_main.fare_rule_x_conc_level_in_use;

select * from abp_main.fare_rule_in_use frin
where frin.EFFECTIVE_DTM + 10/24 >= TO_TIMESTAMP('2019-08-01 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
;

select * from abp_main.fare_rule where fare_rule_id = 678636;

select * from abp_main.fare_rule_x_conc_level_in_use frin
where frin.FARE_RULE_ID = 678637
;

select effective_dtm + 10/24
from abp_main.fare_rule
where fare_rule_id = 727100;

select count(*)
from abp_main.fare_rule fr
-- EDIT THE TIMESTAMP BELOW TO THE EFFECTIVE DATE OF THE LOADED FARE SHEET
where fr.EFFECTIVE_DTM + 10/24 >= TO_TIMESTAMP('2019-08-01 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6');

select count(*)
from ABP_MAIN.FARE_RULE_IN_USE_bkp_020919;

select count(*)
from ABP_MAIN.FARE_RULE_IN_USE;

desc ABP_MAIN.FARE_RULE_IN_USE_bkp_020919;

select *
from abp_main.FARE_RULE_IN_USE_bkp_020919
where FARE_RULE_ID = 678637;

select *
from abp_main.FARE_RULE_IN_USE
where FARE_RULE_ID = 678637;

select count(*) 
from abp_main.fare_rule_in_use;

select count(*)
from abp_main.fare_rule_x_conc_level_in_use;

desc abp_main.sys_info;

select MAX_FARE_RULE_EFFECTIVE_DTM + 10/24
from abp_main.sys_info;

update ABP_MAIN.SYS_INFO
set MAX_FARE_RULE_EFFECTIVE_DTM  = TO_TIMESTAMP('2019-08-26 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') -10/24
;

-- PLAYGROUND
select column_name, data_type, data_length
from all_tab_columns
where table_name = 'TRIP'
--and column_name = 'TRIP_ID'
;

BEGIN DBMS_SNAPSHOT.REFRESH( '"ABP_MAIN"."FARE_RULE_IN_USE"'); end;
BEGIN DBMS_SNAPSHOT.REFRESH( '"ABP_MAIN"."FARE_RULE_X_CONC_LEVEL_IN_USE"'); end;

desc abp_main.fare_rule;
desc abp_main.fare_rule_x_conc_level;

select * from abp_main.FARE_RULE_X_bk2019;


select count(*)
from abp_main.fare_rule fr
-- EDIT THE TIMESTAMP BELOW TO THE EFFECTIVE DATE OF THE LOADED FARE SHEET
where fr.EFFECTIVE_DTM + 10/24 >= TO_TIMESTAMP('2019-08-12 11:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6');

select fr.fare_rule_id, fr.entry_locale_id, fr.exit_locale_id, frxc.fare_amt, fr.effective_dtm
from abp_main.fare_rule fr
left join abp_main.fare_rule_x_conc_level frxc
on fr.FARE_RULE_ID = frxc.FARE_RULE_ID
where fr.entry_locale_id = '555' and fr.exit_locale_id = '554'
;

delete from abp_main.fare_rule
where FARE_RULE_ID in ('1292030','1292029')
;

delete from abp_main.fare_rule_x_conc_level
where FARE_RULE_ID in ('1292030','1292029')
;

update abp_main.fare_rule
set IS_VALID_FLAG = 0
where JOB_ID = '1384';


select * from abp_main.fare_rule_x_conc_level
where entry_locale_id = '554' and exit_locale_id = '555'
;

select *
from abp_main.job
order by job_id desc;

select *
from locale
where system_id = 555;

update abp_main.job
set JOB_STATUS_ID = 3
where job_id = '222';

desc abp_main.fare_rule;

select count(*) from abp_main.fare_rule where job_id = 641;

select cnl.negative_list_id, cnl.token_id, cnl.transit_account_id, cnl.status_changed_dtm, cnl.list_action, cnl.token_digest,
cnl.token_key_storage_id, cnl.bankcard_partial, cnl.token_status_id, cnl.token_type_id, cnl.token_partial
from abp_main.current_negative_list cnl
where token_digest is null;

select trip_id, entry_stop_id, entry_locale_id, exit_stop_id, exit_locale_id, entry_stop_system_id, exit_stop_system_id, calculated_fare, fare_due, paid_amt, cap_amt from abp_main.trip
where TRIP_ID = 497057;

select *
from abp_main.trip
where TRIP_ID = 6006500;

select * from abp_main.fare_rule
where 
ENTRY_LOCALE_ID = '307'
and EXIT_LOCALE_ID = '307'
and IS_VALID_FLAG = 1
;

define TestTime = TO_DATE('26/JUN/2019', 'DD/MM/YYYY')
select TRIP_ID, INSERTED_DTM + 10/24 
from abp_main.trip
--where ENTRY_TRANSACTION_DTM + 10/24 >= &TestTime + 21/24 + 12/(24*60)
where INSERTED_DTM + 10/24 >=&TestTime + 22/24 + 4/(24*60)
and INSERTED_DTM + 10/24 < &TestTime + 22/24 + 9/(24*60)
order by INSERTED_DTM asc
;

select tp.INSERTED_DTM + 10/24, tp.*
from abp_main.tap tp
where INSERTED_DTM + 10/24 >=&TestTime + 22/24 + 4/(24*60)
and INSERTED_DTM + 10/24 < &TestTime + 22/24 + 9/(24*60)
order by INSERTED_DTM asc
;

select tp.TRANSACTION_DTM + 10/24, tp.* 
from abp_main.tap tp
where tap_id  in (
12825664,
12823761
)
;

select tp.TRANSACTION_DTM + 10/24, tp.* 
from abp_main.tap tp
where tap_id  in (
11745047,
11586205,
12077860,
12129915,
12138835
)
;

select *
from ABP_MAIN.TRANSIT_ACCOUNT_X_TOKEN
where TRANSIT_ACCOUNT_ID = 100001244142
;

select nl.STATUS_CHANGED_DTM + 10/24, nl.*
from ABP_MAIN.NEGATIVE_LIST nl
where nl.TOKEN_ID in (
124461,
138395
)
;

select *
from abp_main.tap tp
where TRIP_ENTRY_EXIT_ID = 12
and TAP_STATUS_ID = 700
and TRANSACTION_DTM + 10/24 >=&TestTime + 4/24
and TRANSACTION_DTM + 10/24 < &TestTime + 4/24 + 1
;

select TRIP_ID, INSERTED_DTM + 10/24 
from abp_main.trip
where ENTRY_TAP_ID = 12826948
or EXIT_TAP_ID = 12826948
;

select * from ABP_MAIN.TAP where TAP_ID = 12825664;

select *
from abp_main.journal_entry
where JOURNAL_ENTRY_ID = 1692095
;

select trip_id, transit_account_id, entry_transaction_dtm + 11/24, exit_transaction_dtm + 11/24, 
calculated_fare, fare_due, paid_amt, writeoff_amt, unpaid_amt, inserted_dtm + 11/24, updated_dtm + 11/24, uncollectible_amt
from abp_main.trip
where ENTRY_TAP_ID = 12825664
;


-- FIND JOURNAL ENTRIES WHERE THE UNCOLLECTIBLE AMT <> PAID AMT
select tr.trip_id, tr.transit_account_id, tr.entry_transaction_dtm + 11/24, tr.exit_transaction_dtm + 11/24, 
tr.calculated_fare, tr.fare_due, tr.paid_amt, tr.writeoff_amt, tr.unpaid_amt, tr.uncollectible_amt, tr.inserted_dtm + 11/24, tr.updated_dtm + 11/24,
ta.CURRENT_BALANCE, ta.TD_DEBT_COLL_NBR_ATTEMPTS
from ABP_MAIN.TRIP tr
join ABP_MAIN.TRANSIT_ACCOUNT ta
on tr.TRANSIT_ACCOUNT_ID = ta.TRANSIT_ACCOUNT_ID
where tr.FARE_DUE <> 0
and tr.UNCOLLECTIBLE_AMT <> tr.FARE_DUE
and tr.UNCOLLECTIBLE_AMT <> 0
--and tr.paid_amt = 0
--and tr.UNCOLLECTIBLE_AMT <> ta.CURRENT_BALANCE * -1
order by tr.EXIT_TRANSACTION_DTM desc
;

select *
from API_LOG
where 
REQUEST_TIMESTAMP like '%17/JUN/19%'
order by API_LOG_ID desc
;

update ABP_MAIN.TRIP tr
set tr.WRITEOFF_AMT = 0, tr.UNCOLLECTIBLE_AMT = 0
where tr.TRIP_ID = 195177
;

update ABP_MAIN.TRANSIT_ACCOUNT ta
set ta.CURRENT_BALANCE = 13
where ta.TRANSIT_ACCOUNT_ID = 110000070638
;

select tr.trip_id, tr.transit_account_id, tr.entry_transaction_dtm + 11/24, tr.exit_transaction_dtm + 11/24, 
tr.calculated_fare, tr.fare_due, tr.paid_amt, tr.writeoff_amt, tr.unpaid_amt, tr.uncollectible_amt, tr.inserted_dtm + 11/24, tr.updated_dtm + 11/24
from ABP_MAIN.TRIP tr
where tr.TRIP_ID = 1807126
;
----------------------------------------------------------------------
-- SEARCH A JOURNAL ENTRY BY RRN
----------------------------------------------------------------------
select je.*, bp.*
from ABP_MAIN.JOURNAL_ENTRY je
join ABP_MAIN.BANKCARD_PAYMENT bp
on je.BANKCARD_PAYMENT_ID = bp.BANKCARD_PAYMENT_ID
where bp.PG_RETRIEVAL_REF_NBR = '000021507657'
;
--====================================================================

-- GET NUMBER OF DEBT COLLECTIONS FOR A CERTAIN DAY
----------------------------------------------------------------------
with DebtCollections as (
    select * 
    from ABP_MAIN.JOURNAL_ENTRY
    where 
    TRANSACTION_DTM + &timezone_mod/24 >= &TestDate + &timezone_mod/24
    and TRANSACTION_DTM + &timezone_mod/24 <= &TestDate + 1 + &timezone_mod/24
    and JOURNAL_ENTRY_TYPE_ID = 101
)
select TRANSIT_ACCOUNT_ID, COUNT(JOURNAL_ENTRY_ID)
from DebtCollections
group by TRANSIT_ACCOUNT_ID
;
----------------------------------------------------------------------


-- GET NUMBER OF MANUAL ADJUSTMENTS ON PREVIOUS DAY UNCOLLECTIBLE TRIPS FOR A GIVEN DAY
----------------------------------------------------------------------
--define EndDate = TO_DATE('04/DEC/2018 00:00:00', 'DD/MM/YYYY HH24:MI:SS'); 
--define EndDate2 = TO_DATE('05/DEC/2018 00:00:00', 'DD/MM/YYYY HH24:MI:SS'); 
define timezone_mod = 10;
define TestDate = TO_DATE('24/JUN/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
with UncollectibleTrips as (
    select * 
    from ABP_MAIN.JOURNAL_ENTRY
    where 
    TRANSACTION_DTM + &timezone_mod/24 >= &TestDate + &timezone_mod/24
    and TRANSACTION_DTM + &timezone_mod/24 <= &TestDate + 1 + &timezone_mod/24
    and JOURNAL_ENTRY_TYPE_ID = 108
), ManualAdjustments as (
    select * 
    from ABP_MAIN.JOURNAL_ENTRY
    where 
    TRANSACTION_DTM + &timezone_mod/24 >= &TestDate + 1 + &timezone_mod/24
    and TRANSACTION_DTM + &timezone_mod/24 <= &TestDate + 2 + &timezone_mod/24
    and JOURNAL_ENTRY_TYPE_ID = 102
)
select ut.JOURNAL_ENTRY_ID, ut.TRANSIT_ACCOUNT_ID, ut.JOURNAL_ENTRY_TYPE_ID, ut.TRIP_ID, ma.REFERENCE_INFO,
    ut.TRANSACTION_DTM + &timezone_mod/24 "Uncollectible Txn time",
    ut.TRANSACTION_AMT "Uncollectible amt", ma.TRANSACTION_AMT "Manual Adj amt", ma.JOURNAL_ENTRY_ID "Manual Adj JE#", ma.JOURNAL_ENTRY_TYPE_ID "Manual Adj JEType",
    ma.TRANSACTION_DTM + &timezone_mod/24 "Manual Adjustment time"
from UncollectibleTrips ut
join ManualAdjustments ma
on ut.TRANSIT_ACCOUNT_ID = ma.TRANSIT_ACCOUNT_ID
where ma.REFERENCE_INFO like '%' || ut.TRIP_ID || '%'
and ut.TRANSACTION_AMT + ma.TRANSACTION_AMT <> 0
;

select *
from ABP_MAIN.JOURNAL_ENTRY
where 
JOURNAL_ENTRY_TYPE_ID = 101
and TRANSACTION_DTM + &timezone_mod/24 >= &TestDate + 1 + &timezone_mod/24
and TRANSIT_ACCOUNT_ID in (
100003490404,
100004223119,
100004646608,
100004646772,
100006184723,
100001660131,
100006332470,
100004105803,
100002722989,
100002048849,
100002878054,
100006028763,
100007014424,
100003065784,
100001950177,
100004073076,
100002962494,
100004330518,
100002026811,
100002352118,
100005646086,
100007065095,
100001931847,
100004804066,
100001899879,
100004245005,
100005283401,
100007062316,
100006762403,
100007027947,
100001352689,
100003680624,
100006670192,
100006844797,
100006747792,
100007044249
)
;
----------------------------------------------------------------------

select *
from ABP_MAIN.JOURNAL_ENTRY
where JOURNAL_ENTRY_ID in (4824931, 4824932, 4824933);

-- REPORT FOR HOW MANY ARE AFFECTED BY THE PARTIAL ADJUSTMENTS ISSUE
--with TestDate as (
--    select 
--    --AN ARBITRARY TEST DATE
--        TO_DATE('04/DEC/2018 00:00:00') testDate
--    from dual
--), OtherDate as (
--    select 
--        TO_DATE('05/DEC/2018 00:00:00') otherdate
--    from dual
--), FirstDate as (
--    select 
--        TO_DATE('03/DEC/2018 00:00:00') otherdate
--    from dual
--), ManualAdjustmentEntries as (
--    select je1.JOURNAL_ENTRY_ID, je1.TRANSIT_ACCOUNT_ID, je1.JOURNAL_ENTRY_TYPE_ID, je1.TRANSACTION_DTM, je1.TRANSACTION_AMT, je1.REFERENCE_INFO
--    from ABP_MAIN.JOURNAL_ENTRY je1
--    where je1.JOURNAL_ENTRY_TYPE_ID = 102
--    and je1.TRANSACTION_DTM + 11/24 >= (SELECT * FROM TestDate) +4/24
--    and je1.TRANSACTION_DTM + 11/24 <= (SELECT * FROM OtherDate) +4/24
--), UncollectibleTripEntries as (
--    select je1.JOURNAL_ENTRY_ID, je1.TRANSIT_ACCOUNT_ID, TO_CHAR(je1.TRIP_ID) as TRIP_ID, je1.JOURNAL_ENTRY_TYPE_ID, je1.TRANSACTION_DTM, je1.TRANSACTION_AMT, je1.REFERENCE_INFO
--    from ABP_MAIN.JOURNAL_ENTRY je1
--    where je1.JOURNAL_ENTRY_TYPE_ID = 108
--    and je1.TRANSACTION_DTM + 11/24 >= (SELECT * FROM FirstDate) +4/24
--    and je1.TRANSACTION_DTM + 11/24 <= (SELECT * FROM TestDate) +4/24
--)
--select je2.*
--from UncollectibleTripEntries je2
--inner join ManualAdjustmentEntries je1
--on je2.TRANSIT_ACCOUNT_ID = je1.TRANSIT_ACCOUNT_ID
----where je2.TRIP_ID like '%386604%'
--;

update abp_main.trip
set 
--entry_stop_id = 330,
--entry_locale_id = 330,
--entry_stop_system_id = 330
--exit_stop_id = 235,
--exit_locale_id = 235,
--exit_stop_system_id = 235
fare_due = 0,
paid_amt = 0,
cap_amt = 869
where TRIP_ID = 497059;

-- FIND ALL FARE RULES LOADED TO ABP
select distinct effective_dtm + 10/24, IS_VALID_FLAG, count(*) from abp_main.fare_rule group by effective_dtm + 10/24, IS_VALID_FLAG order by effective_dtm + 10/24 desc;
select count(*) from abp_main.fare_rule fr where fr.effective_dtm + 10/24 = &TestDate;

desc abp_main.fare_rule;
desc abp_main.fare_rule_x_conc_level;
desc abp_main.locale;
define TestDate = TO_DATE('29/JUL/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');

select loc_entry.DESCRIPTION, fr.ENTRY_LOCALE_ID, loc_exit.DESCRIPTION, fr.EXIT_LOCALE_ID, frc.FARE_AMT, 0, fr.EFFECTIVE_DTM + 10/24
from abp_main.fare_rule fr
join abp_main.fare_rule_x_conc_level frc on fr.fare_rule_id = frc.fare_rule_id
join abp_main.locale loc_entry on loc_entry.system_id = fr.ENTRY_LOCALE_ID
join abp_main.locale loc_exit on loc_exit.system_id = fr.EXIT_LOCALE_ID
where fr.effective_dtm + 10/24 = &TestDate
order by fr.ENTRY_LOCALE_ID asc
;


select fr.entry_locale_id, fr.exit_locale_id, frc.fare_amt, fr.EFFECTIVE_DTM, fr.INSERTED_DTM, frc.INSERTED_DTM
from abp_main.fare_rule fr
join abp_main.fare_rule_x_conc_level frc
on fr.fare_rule_id = frc.fare_rule_id
where fr.JOB_ID = 221
order by fr.fare_rule_id desc
;

select count(*)
from ABP_MAIN.FARE_RULE_x_conc_level
where fare_rule_id >= 454779
order by fare_rule_id asc
;

update abp_main.fare_rule
set is_valid_flag = 0
where JOB_ID = 1183
;

-- FIND ALL VALID RULES ONLY
select distinct effective_dtm, IS_VALID_FLAG, count(*)
from abp_main.fare_rule 
where is_valid_flag = 1
group by effective_dtm, IS_VALID_FLAG order by effective_dtm desc;

select distinct *
from abp_main.fare_rule 
where is_valid_flag = 1
and effective_dtm + 10/24 = to_timestamp('2019-07-29 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
;

select distinct effective_dtm, IS_VALID_FLAG, count(*)
from abp_main.fare_rule 
where EFFECTIVE_DTM < to_timestamp('2019-06-23 18:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6')
group by effective_dtm, IS_VALID_FLAG order by effective_dtm desc;

select *
from abp_main.fare_rule
where is_valid_flag = 1
--and EFFECTIVE_DTM like '%02/JUN/19%'
;

select *
from ABP_MAIN.JOB
order by job_id desc
;

update JOB
set job_status_id = 3
where JOB_ID = 221;

select * 
from ABP_MAIN.TRIP
where TRIP_ID = 193047
order by TRIP_ID DESC;

select *
from ABP_MAIN.FARE_RULE
where 
--FARE_RULE_ID = 2020678
ENTRY_LOCALE_ID = '100'
and EXIT_LOCALE_ID = '102'
order by effective_dtm desc
;

-- ============= Undercharging no SAF ==============
-- V0.4
-- set startdate
with StartDate as (
    select 
--        Stage 128 - HR deployment was completed on the 26th of Nov
        TO_DATE('26/NOV/2018 00:00:00') startdate
    from dual
),
EndDate as (
    select 
--        DST ended on 7th Apr 2019; a separate report must be run and added for this
        TO_DATE('06/APR/2019 00:00:00') enddate
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
        entry_transaction_dtm +11/24 >= (SELECT * FROM StartDate) +4/24
        AND entry_transaction_dtm +11/24 <= (SELECT * FROM EndDate) + 4/24
        AND void_type is null
),
daily_total as (
    SELECT 
        trip_id,
        data.entry_transaction_dtm +11/24 as day,
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
                    when 270 - (running_paid_amount_total - underpaid_amount) > 0 then 270 - (running_paid_amount_total - underpaid_amount)
                    else 0
                end)
                else
                (case 
                    when 1580 - (running_paid_amount_total - underpaid_amount) > 0 then 1580 - (running_paid_amount_total - underpaid_amount)
                    else 0
                end)
            end)
      end)
 as underpaid_amount_final
from daily_capped_check dcc
)
select 
   *
--   count(*),
--   sum(underpaid_amount_final)
from daily_sum_underpaid
where underpaid_amount != 0
--and fare_paid_wo_saf = 0
and capping_scheme is not null
and capping_scheme not like '%Weekly%Cap%'
order by day
;

-- ============= Undercharging no SAF ==============
-- V0.4
-- set startdate
with StartDate as (
    select 
--        Stage 128 - HR deployment was completed on the 26th of Nov
--		This report picks up records commencing DST ended date, i.e. 7th Apr 2019.
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
        entry_transaction_dtm +10/24 >= (SELECT * FROM StartDate) +4/24
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
                    when 270 - (running_paid_amount_total - underpaid_amount) > 0 then 270 - (running_paid_amount_total - underpaid_amount)
                    else 0
                end)
                else
                (case 
                    when 1580 - (running_paid_amount_total - underpaid_amount) > 0 then 1580 - (running_paid_amount_total - underpaid_amount)
                    else 0
                end)
            end)
      end)
 as underpaid_amount_final
from daily_capped_check dcc
)
select 
   *
--   count(*),
--   sum(underpaid_amount_final)
from daily_sum_underpaid
where underpaid_amount != 0
--and fare_paid_wo_saf = 0
and capping_scheme is not null
and capping_scheme not like '%Weekly%Cap%'
order by day
;

--Count of Heavy Rail Trips by Type since Launch
select *
from ABP_MAIN.TRIP
where TRANSIT_ACCOUNT_ID = '100004946289';

SELECT TRIP_TYPE_DESCRIPTION, count(*) 
from 
(select trp.entry_transaction_dtm + 11/24,trp.trip_id,trp.transit_account_id,trp.token_id,trp.entry_transaction_dtm,lc1.description,trp.entry_stop_id,lc2.description,trp.exit_stop_id,tp1.device_id,tp2.device_id, 
CASE
           WHEN TRP.VOID_FLAG = 1
           THEN 'Void' -- VOID 
           ELSE (
                 CASE 
                     WHEN (TRP.ENTRY_STOP_ID = TRP.EXIT_STOP_ID AND TRP.FARE_DUE = 0 AND TP1.TAP_TYPE_ID != 2 and TP2.TAP_TYPE_ID != 2 and TRP.CAP_AMT = 0 ) THEN 'Reversed'
                     ELSE (
                           CASE 
                               WHEN (TP1.TAP_TYPE_ID = 2 AND TRP.Entry_Transaction_DTM = TRP.Exit_Transaction_DTM) THEN 'Unstarted'
                               WHEN (TP2.TAP_TYPE_ID = 2 AND TRP.Entry_Transaction_DTM = TRP.Exit_Transaction_DTM) THEN 'Unfinished'  
                               ELSE 'Completed'
                           END)
                 END)      
      END AS Trip_Type_Description
from abp_main.trip trp 
join abp_main.tap tp1 on trp.entry_tap_id = tp1.tap_id
join abp_main.tap tp2 on trp.exit_tap_id = tp2.tap_id
join abp_main.locale lc1 on trp.ENTRY_STOP_ID = lc1.locale_id
join abp_main.locale lc2 on trp.exit_stop_id = lc2.locale_id
where trp.ENTRY_OPERATOR_ID = 1000
and  trp.entry_transaction_dtm > '25/NOV/18 00:20:00'
order by trp.entry_transaction_dtm desc)
group by Trip_Type_Description;


--Business Rule Exception
SELECT *
FROM abp_main.tap
WHERE TAP_STATUS_DESCRIPTION LIKE '%BRE%'
  AND TRANSACTION_DTM > '13/OCT/18 12:00:00'
ORDER BY Transaction_dtm DESC;

--Unmatched Taps more than 34 minutes
SELECT *
FROM ABP_MAIN.TAP
WHERE UNMATCHED_FLAG = 2
  AND transaction_dtm <= sys_extract_utc(systimestamp - INTERVAL '34' minute(1))
ORDER BY transaction_dtm DESC;

--Tap delay
SELECT tap_id,
       device_id,
       transaction_dtm +11/24 as Tap_occurred_time_Sydney,
       transaction_dtm as Tap_occurred_time_UTC,
       inserted_dtm as Tap_received_time_UTC,
       token_id,
       transit_account_id,
       stop_id,
       CASE
           WHEN (cast(inserted_dtm AS date) - cast(transaction_dtm AS date)) *24*60 < 0 THEN 0
           ELSE (cast(inserted_dtm AS date) - cast(transaction_dtm AS date)) *24*60
       END AS DIFF
FROM abp_main.tap
WHERE device_id NOT LIKE 'ABP%'
  and transaction_dtm > '/NOV/18 01:30:00'
  --and transaction_dtm < '28/OCT/18 05:00:00.000000000 PM'
ORDER BY inserted_dtm DESC;

select * from abp_main.locale
where locale_id like '451'
;

-- INC1661793 investigation
select t.INSERTED_DTM, t.price_count, t.*
from abp_main.trip t
where trip_id = 3145271
;

