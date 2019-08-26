define l_testTransitAccountID = 100004414593 ;
define l_timezoneModifier = 10;

/* Find Trips in ABP for a day */
select tr.TRIP_ID, tr.TRANSIT_ACCOUNT_ID, tr.TOKEN_ID, tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24 as ENTRY_DTM,
tr.EXIT_TRANSACTION_DTM + &l_timezoneModifier/24 as EXIT_DTM,
--tr.ENTRY_STOP_SYSTEM_ID, tr.EXIT_STOP_SYSTEM_ID, 
loc_entry.DESCRIPTION as ENTRY_LOC, loc_exit.DESCRIPTION as EXIT_LOC,
tr.PEAK_OFFPEAK_ID, tr.JOURNEY_ID, tr.FARE_RULE_ID, tr.MISSING_TAP_FLAG, tr.PRICE_COUNT, tr.PRICING_STATUS, tr.CALCULATED_FARE,
tr.CALCULATED_FEE, tr.FARE_DUE, tr.PAID_AMT, tr.CAP_AMT, tr.INSERTED_DTM + &l_timezoneModifier/24, tr.UPDATED_DTM + &l_timezoneModifier/24
from abp_main.trip tr
left join abp_main.locale loc_entry
on tr.ENTRY_STOP_SYSTEM_ID = loc_entry.SYSTEM_ID
left join abp_main.locale loc_exit
on tr.EXIT_STOP_SYSTEM_ID = loc_exit.SYSTEM_ID
where tr.TRANSIT_ACCOUNT_ID = &l_testTransitAccountID
and tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24 between TO_DATE('21/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS') and
TO_DATE('22/AUG/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS')
order by tr.INSERTED_DTM desc
;

-- ALL records with different amounts between ABP and CPA, post-7/Apr/2019
select bp.INSERTEDDTM +10/24,bp.bankcardpaymentid,bp.transitaccountid,bp.PGRETRIEVALREFNBR,bp.PGSETTLEMENTAMT as ABP_Amount,c.I004AMOUNTTRANSACTION as CPA_Amount from emv.bankcard_payment bp
join emv.confirmation c on bp.pgretrievalrefnbr = c.I037RETRIEVALREFERENCENUM
where bp.PGSETTLEMENTAMT != c.I004AMOUNTTRANSACTION
and bp.INSERTEDDTM +10/24 < sysdate -1
order by bankcardpaymentid desc
;

-- ALL records with different amounts between ABP and CPA, pre-7/Apr/2019
select bp.INSERTEDDTM +11/24,bp.bankcardpaymentid,bp.transitaccountid,bp.PGRETRIEVALREFNBR,bp.PGSETTLEMENTAMT as ABP_Amount,c.I004AMOUNTTRANSACTION as CPA_Amount from emv.bankcard_payment bp
join emv.confirmation c on bp.pgretrievalrefnbr = c.I037RETRIEVALREFERENCENUM
where bp.PGSETTLEMENTAMT != c.I004AMOUNTTRANSACTION
order by bankcardpaymentid desc
;