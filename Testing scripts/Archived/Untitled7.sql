define l_timezoneModifier = 10;
define TestDate = TO_DATE('05/AUG/2019 00:04:00', 'DD/MM/YYYY HH24:MI:SS');

select tr.TRIP_ID, tr.TRANSIT_ACCOUNT_ID, tr.TOKEN_ID, tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24, tr.EXIT_TRANSACTION_DTM + &l_timezoneModifier/24,
tr.ENTRY_STOP_SYSTEM_ID, tr.EXIT_STOP_SYSTEM_ID, loc_entry.DESCRIPTION, loc_exit.DESCRIPTION,
tr.PEAK_OFFPEAK_ID, tr.JOURNEY_ID, tr.FARE_RULE_ID, tr.MISSING_TAP_FLAG, tr.PRICE_COUNT, tr.PRICING_STATUS, tr.CALCULATED_FARE,
tr.CALCULATED_FEE, tr.FARE_DUE, tr.PAID_AMT, tr.CAP_AMT, tr.INSERTED_DTM + &l_timezoneModifier/24, tr.UPDATED_DTM + &l_timezoneModifier/24
from abp_main.trip tr
left join abp_main.locale loc_entry
on tr.ENTRY_STOP_SYSTEM_ID = loc_entry.SYSTEM_ID
left join abp_main.locale loc_exit
on tr.EXIT_STOP_SYSTEM_ID = loc_exit.SYSTEM_ID
where tr.TRANSIT_ACCOUNT_ID = &l_testTransitAccountID
order by tr.INSERTED_DTM desc
;

desc emv.TRIp;
desc emv.journal_entry;

define TestDate = TO_DATE('05/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS'); -- Datetime + 6 days to be looked at

WITH TRIPS_GT_EIGHTJNYS as (
    select count(distinct tr.journeyid) as FOUCOUNT, tr.tokenid, tr.transitaccountid
    from emv.trip tr 
    where 
    tr.ENTRYTRANSACTIONDTM + 10/24 > TO_DATE('05/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') and tr.ENTRYTRANSACTIONDTM + 10/24 < TO_DATE('05/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') + 7
    and tr.DEFAULTFAREFLAG = 0
    group by tr.tokenid, tr.transitaccountid
    having count(distinct tr.journeyid) > 8
),
ACCOUNTS_W_FOUDCNT as (
    select count (je.journalentryid) as FOUDISCOUNTRECORDS, je.transitaccountid
    from emv.journal_entry je
    where 
    je.TRANSACTIONDTM + 10/24 > TO_DATE('05/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') and je.TRANSACTIONDTM + 10/24 < TO_DATE('05/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') + 7
    and je.CAPPINGSCHEMEDESCRIPTION = 'Frequency of Use Discount'
    group by je.transitaccountid
)
select tre.TRANSITACCOUNTID, tre.TOKENID, tre.FOUCOUNT, awfou.FOUDISCOUNTRECORDS,
(case when awfou.FOUDISCOUNTRECORDS is null then 'N'
else 'Y'
end) as FOUAPPLIEDFLAG
from TRIPS_GT_EIGHTJNYS tre
left join ACCOUNTS_W_FOUDCNT awfou on tre.TRANSITACCOUNTID = awfou.TRANSITACCOUNTID
;




WITH ACCOUNTS_W_NO_FOUDCNT as (
    select count (je.journalentryid), je.transitaccountid
    from emv.journal_entry je
    where 
    je.TRANSACTIONDTM + 10/24 > &TestDate and je.TRANSACTIONDTM + 10/24 < &TestDate + 7
    and je.CAPPINGSCHEMEDESCRIPTION = 'Frequency of Use Discount'
    group by je.transitaccountid
)
select *
from ACCOUNTS_W_NO_FOUDCNT;

select *
from emv.journal_entry je
where je.journalentryid = '9889546';

select 
from emv.journalentry je
