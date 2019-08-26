alter session set current_schema = ABP_MAIN;

desc abp_main.TRIP;

define l_someTripID = 8263721;
define l_timezoneModifier = 10;
/* Look up a Trip by TRIP ID
*/
select tr.TRIP_ID, tr.TRANSIT_ACCOUNT_ID, tr.TOKEN_ID, tr.ENTRY_TAP_ID, tr.EXIT_TAP_ID,
tr.ENTRY_TRANSACTION_DTM + &l_timezoneModifier/24, tr.EXIT_TRANSACTION_DTM + &l_timezoneModifier/24,
tr.ENTRY_STOP_SYSTEM_ID, tr.EXIT_STOP_SYSTEM_ID, loc_entry.DESCRIPTION, loc_exit.DESCRIPTION,
tr.PEAK_OFFPEAK_ID, tr.JOURNEY_ID, tr.FARE_RULE_ID, tr.MISSING_TAP_FLAG, tr.PRICE_COUNT, tr.PRICING_STATUS, tr.CALCULATED_FARE,
tr.CALCULATED_FEE, tr.FARE_DUE, tr.PAID_AMT, tr.CAP_AMT, tr.TRANSFER_FLAG,
tr.CAPPING_TOTALS,
tr.INSERTED_DTM + &l_timezoneModifier/24, tr.UPDATED_DTM + &l_timezoneModifier/24
from abp_main.trip tr
join abp_main.locale loc_entry
on tr.ENTRY_STOP_SYSTEM_ID = loc_entry.SYSTEM_ID
join abp_main.locale loc_exit
on tr.EXIT_STOP_SYSTEM_ID = loc_exit.SYSTEM_ID
where tr.TRIP_ID in &l_someTripID
order by tr.INSERTED_DTM desc
;


select tr.tripid, tr.transitaccountid, tr.entryoperatorid, tr.exitoperatorid, tr.entrystopid, tr.exitstopid, 
(case when ram.apportionedoperatorid = '44' then '44 - Sydney Trains'
when  ram.apportionedoperatorid = '45' then '45 - NSW Trainlink'
when ram.apportionedoperatorid = '37' then '37 - Metro Trains Sydney'
when opr.ETSOPERATORID = '1' then '1 - Sydney Ferries'
when opr.ETSOPERATORID = '46' then '46 - Sydney Light Rail'
when opr.ETSOPERATORID = '38' then '38 - Newcastle Transport'
else 'No idea'
end) as RAIL_OPERATOR_NAME
from emv.TRIP tr
left join emv.ETS_RAIL_APPORTIONMENT_MATRIX ram on (tr.ENTRYSTOPID = ram.ENTRYNLC and tr.EXITSTOPID = ram.EXITNLC)
left join emv.ETS_OPERATOR opr on (opr.NLC = tr.ENTRYSTOPID)
where tr.TRIPID in (
)
order by tripid desc;

select * from emv.ETS_RAIL_APPORTIONMENT_MATRIX
where entrynlc = '936' and exitnlc = '936';

select * from EMV.ETS_OPERATOR where TRANSPORTMODE = 'LIGHT RAIL';

select * from ALL_VIEWS where OWNER = 'EMV';