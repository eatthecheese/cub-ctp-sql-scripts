/* Define a transit_account_id & timezone modifier for the below queries
*/
define l_testTransitAccountID = 100014913584;
define l_timezoneModifier = 10;
define TestDate = TO_DATE('31/JUL/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');

/* Look up the Trip history for a transit account like the GUI
Modify this so we can search by other parameters?
*/
select tr.TRIP_ID, tr.TRANSIT_ACCOUNT_ID, tr.TOKEN_ID, tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24 as ENTRY_DTM,
tr.EXIT_TRANSACTION_DTM + &l_timezoneModifier/24 as EXIT_DTM,
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

/* Define a time period as well
*/
select tr.TRIP_ID, tr.TRANSIT_ACCOUNT_ID, tr.TOKEN_ID, tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24 as ENTRY_DTM,
tr.EXIT_TRANSACTION_DTM + &l_timezoneModifier/24 as EXIT_DTM,
tr.ENTRY_STOP_SYSTEM_ID, tr.EXIT_STOP_SYSTEM_ID, loc_entry.DESCRIPTION, loc_exit.DESCRIPTION,
tr.PEAK_OFFPEAK_ID, tr.JOURNEY_ID, tr.FARE_RULE_ID, tr.MISSING_TAP_FLAG, tr.PRICE_COUNT, tr.PRICING_STATUS, tr.CALCULATED_FARE,
tr.CALCULATED_FEE, tr.FARE_DUE, tr.PAID_AMT, tr.CAP_AMT, tr.INSERTED_DTM + &l_timezoneModifier/24, tr.UPDATED_DTM + &l_timezoneModifier/24
from abp_main.trip tr
left join abp_main.locale loc_entry
on tr.ENTRY_STOP_SYSTEM_ID = loc_entry.SYSTEM_ID
left join abp_main.locale loc_exit
on tr.EXIT_STOP_SYSTEM_ID = loc_exit.SYSTEM_ID
where tr.TRANSIT_ACCOUNT_ID = &l_testTransitAccountID
and tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24 between TO_DATE('18/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') and
TO_DATE('19/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS')
order by tr.INSERTED_DTM desc
;

desc abp_main.trip;
define l_someTripID = 7979637;
define l_someJourneyID = 7845150;
/* Look up a Trip by TRIP ID
*/
select tr.TRIP_ID, tr.TRANSIT_ACCOUNT_ID, tr.TOKEN_ID, tr.ENTRY_TAP_ID, tr.EXIT_TAP_ID,
tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24, tr.EXIT_TRANSACTION_DTM + &l_timezoneModifier/24,
tr.ENTRY_STOP_SYSTEM_ID, tr.EXIT_STOP_SYSTEM_ID, loc_entry.DESCRIPTION, loc_exit.DESCRIPTION,
tr.PEAK_OFFPEAK_ID, tr.JOURNEY_ID, tr.FARE_RULE_ID, tr.MISSING_TAP_FLAG, tr.PRICE_COUNT, tr.PRICING_STATUS, tr.CALCULATED_FARE,
tr.CALCULATED_FEE, tr.FARE_DUE, tr.PAID_AMT, tr.CAP_AMT, tr.TRANSFER_FLAG, tr.INSERTED_DTM + &l_timezoneModifier/24, tr.UPDATED_DTM + &l_timezoneModifier/24
from abp_main.trip tr
join abp_main.locale loc_entry
on tr.ENTRY_STOP_SYSTEM_ID = loc_entry.SYSTEM_ID
join abp_main.locale loc_exit
on tr.EXIT_STOP_SYSTEM_ID = loc_exit.SYSTEM_ID
where tr.TRIP_ID in &l_someTripID
order by tr.INSERTED_DTM desc
;

desc abp_main.locale;
desc abp_main.trip;

select * from abp_main.LOCALE loc
where loc.SYSTEM_ID = 251738
;


/* Look up Tap history for a TAP_ID
*/
define l_timezoneModifier = 10;
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
where tp.TAP_ID = 15909920
order by tp.TRANSACTION_DTM desc
;

/* Look up Tap history for a transit account like the GUI
*/
define l_timezoneModifier = 10;
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
order by tp.TRANSACTION_DTM desc
;

/* Negative list history by TOKEN_ID
*/
select nl.negative_list_id, nl.token_id, nl.list_action, nl.status_changed_dtm + 10/24, nl.TRANSIT_ACCOUNT_ID
from abp_main.negative_list nl
where nl.token_id = 1493546;

/* Search for a Journal Entry like in the GUI
*/
select je.JOURNAL_ENTRY_ID, je.TRANSIT_ACCOUNT_ID, jetype.DESCRIPTION, je.BANKCARD_PAYMENT_ID, je.TRIP_ID,
je.TRANSACTION_DTM + 10/24, je.TRANSACTION_AMT, je.ACTION_TYPE_ID, je.INSERTED_DTM + 10/24, je.UPDATED_DTM + 10/24,
je.CAPPING_SCHEME_DESCRIPTION, je.REMAINING_AMT, je.PURSE_LOAD_REMAINING_AMT
from abp_main.journal_entry je
join abp_main.journal_entry_type jetype
on je.JOURNAL_ENTRY_TYPE_ID = jetype.JOURNAL_ENTRY_TYPE_ID
where je.TRANSIT_ACCOUNT_ID = &l_testTransitAccountID
order by je.TRANSACTION_DTM desc
;

/* Search for a Bankcard Payment like in the GUI
*/
select bp.BANKCARD_PAYMENT_ID, bp.TRANSIT_ACCOUNT_ID, bpstat.DESCRIPTION, bp.BANKCARD_ID, bp.PG_RETRIEVAL_REF_NBR,
bp.PG_SETTLEMENT_AMT, bp.PG_RESPONSE_CODE, bp.REQUESTED_AMT, bp.AUTHORIZED_AMT,
bp.CARD_PRESENT_FLAG, bp.INSERTED_DTM + 10/24, bp.UPDATED_DTM + 10/24
from abp_main.BANKCARD_PAYMENT bp
join abp_main.BANKCARD_PAYMENT_STATUS bpstat
on bp.BANKCARD_PAYMENT_STATUS_ID = bpstat.BANKCARD_PAYMENT_STATUS_ID
where bp.TRANSIT_ACCOUNT_ID = &l_testTransitAccountID
order by bp.INSERTED_DTM desc
;

/* Search for info on ABP tables
*/
select owner, table_name
from all_tables
where owner = 'ABP_MAIN'
and table_name like '%FLAG%'
;

desc abp_main.BANKCARD_PAYMENT;

/* CPA QUERIES ONLY BELOW THIS POINT
 ABP QUERIES TO THE ABOVE LADIES AND GENTLEMEN
*/
define l_testRRN = '000060281863';

/* Look for a confirmation in CPA
*/
select * from cpa.confirmation
where i037_retrieval_reference_num in (&l_testRRN);

/* Find CPA confirmations for a day */
with CF_PAN_DIGEST as (
    select PAN_DIGEST
    from cpa.confirmation cf
    where cf.I037_RETRIEVAL_REFERENCE_NUM = '000062985339'  
)
select *
from cpa.confirmation cf
join CF_PAN_DIGEST cpd on cf.PAN_DIGEST = cpd.PAN_DIGEST
where  cf.I007_TRANSMISSION_DTM  between TO_DATE('18/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') and
TO_DATE('19/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS')
;

/* Look through the API request log in CPA to find out how the hold + adjust amount calls were made for an RRN
*/
select * from CPA.api_request_log
where retrieval_reference_num = &l_testRRN;

desc emv.JOURNAL_ENTRY;
desc emv.BANKCARD_PAYMENT;
desc emv.CONFIRMATION;
desc emv.TRIP;
/* EMV QUERIES ONLY BELOW THIS POINT
*/
select je.JOURNALENTRYID, je.TRANSITACCOUNTID, je.BANKCARDPAYMENTID, je.TRIPID, je.TRANSACTIONDTM + &l_timezoneModifier/24 as JE_DTM,
tr.ENTRYTRANSACTIONDTM + &l_timezoneModifier/24 as ENTRY_TAP_DTM, tr.EXITTRANSACTIONDTM + &l_timezoneModifier/24 as EXIT_TAP_DTM, tr.TOKENID,
bp.PGRETRIEVALREFNBR as RRN,
tr.FAREDUE as TRIP_FAREDUE, 
je.TRANSACTIONAMT as JE_TXN_AMT, 
bp.PGSETTLEMENTAMT as ABP_SETT_AMT, 
cf.I004AMOUNTTRANSACTION as CPA_AMT, 
je.EMVINSERTEDDTM,  bp.PGSETTLEMENTDTM, bp.PGRESPONSECODE, bp.INSERTEDDTM + &l_timezoneModifier/24,
cf.MSGDTM, cf.MSGSETTLEMENTSTATUS, cf.INSERTEDDTM, cf.UPDATEDDTM
from emv.journal_entry je
full outer join EMV.BANKCARD_PAYMENT bp on je.BANKCARDPAYMENTID = bp.BANKCARDPAYMENTID
join EMV.CONFIRMATION cf on bp.PGRETRIEVALREFNBR = cf.I037RETRIEVALREFERENCENUM 
left join EMV.TRIP tr on tr.TRIPID = je.TRIPID
where je.TRANSITACCOUNTID = &l_testTransitAccountID
order by je.TRANSACTIONDTM desc
;

/* Find accounts who have reached the FOUCOUNT = 8 but didn't get the FOU discount
*/
WITH TRIPS_GT_EIGHTJNYS as (
    select count(distinct tr.journeyid) as FOUCOUNT, tr.tokenid, tr.transitaccountid
    from emv.trip tr 
    where 
    tr.ENTRYTRANSACTIONDTM + 10/24 > TO_DATE('12/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') and tr.ENTRYTRANSACTIONDTM + 10/24 < TO_DATE('12/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') + 7
    group by tr.tokenid, tr.transitaccountid
    having count(distinct tr.journeyid) > 8
),
ACCOUNTS_W_FOUDCNT as (
    select count (je.journalentryid) as FOUDISCOUNTRECORDS, je.transitaccountid
    from emv.journal_entry je
    where 
    je.TRANSACTIONDTM + 10/24 > TO_DATE('12/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') and je.TRANSACTIONDTM + 10/24 < TO_DATE('12/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') + 7
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
