/* find non-zero CPA confirmations for which there are no ABP bankcard payment records */
select cf.MSGDTM, cf.MSGSETTLEMENTSTATUS, cf.PANPARTIAL, cf.CREDITCARDTYPEID, cf.I004AMOUNTTRANSACTION, cf.I004AMOUNTTRANSACTIONORIG,
cf.I007TRANSMISSIONDTM, cf.I037RETRIEVALREFERENCENUM, cf.INSERTEDDTM, cf.UPDATEDDTM
from emv.confirmation cf
left join emv.bankcard_payment bp on cf.I037RETRIEVALREFERENCENUM = bp.PGRETRIEVALREFNBR
where cf.I004AMOUNTTRANSACTION <> 0
and cf.I007TRANSMISSIONDTM  between TO_DATE('12/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') and
TO_DATE('19/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS')
and bp.PGRETRIEVALREFNBR is null
order by cf.I007TRANSMISSIONDTM desc;

/*Find taps for a certain period for a certain transit account */
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
where tp.TRANSACTION_DTM + 10/24 between TO_DATE('01/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') and
TO_DATE('31/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS')
and tp.TRANSIT_ACCOUNT_ID = '100014815854'
order by tp.TRANSACTION_DTM desc
;

/* Find CPA confirmations for a token for a day, given a RRN belonging to that token*/
with CF_PAN_DIGEST as (
    select PAN_DIGEST
    from cpa.confirmation cf
    where cf.I037_RETRIEVAL_REFERENCE_NUM in (
    '000062590336'
    )
)
select cf.PAN_DIGEST, cf.MSG_DTM, cf.MSG_SETTLEMENT_STATUS, cf.PAN_PARTIAL, cf.CREDIT_CARD_TYPE_ID, cf.I004_AMOUNT_TRANSACTION,
cf.I004_AMOUNT_TRANSACTION_ORIG, cf.I007_TRANSMISSION_DTM, cf.I037_RETRIEVAL_REFERENCE_NUM, cf.INSERTED_DTM
from cpa.confirmation cf
join CF_PAN_DIGEST cpd on cf.PAN_DIGEST = cpd.PAN_DIGEST
where  cf.I007_TRANSMISSION_DTM  between TO_DATE('01/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') and
TO_DATE('31/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS')
order by MSG_DTM asc
;

/* Find journal entries given a transit account id */
select je.JOURNAL_ENTRY_ID, je.TRANSIT_ACCOUNT_ID, jetype.DESCRIPTION, je.BANKCARD_PAYMENT_ID, je.TRIP_ID,
je.TRANSACTION_DTM + 10/24, je.TRANSACTION_AMT, je.ACTION_TYPE_ID, je.INSERTED_DTM + 10/24, je.UPDATED_DTM + 10/24,
je.CAPPING_SCHEME_DESCRIPTION, je.REMAINING_AMT, je.PURSE_LOAD_REMAINING_AMT
from abp_main.journal_entry je
join abp_main.journal_entry_type jetype
on je.JOURNAL_ENTRY_TYPE_ID = jetype.JOURNAL_ENTRY_TYPE_ID
where je.TRANSIT_ACCOUNT_ID = '100014815854'
order by je.TRANSACTION_DTM desc
;
