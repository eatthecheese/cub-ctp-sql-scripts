select *
from ABP_MAIN.TRANSIT_ACCOUNT
where TRANSIT_ACCOUNT_ID = '100004946289';

select transit_account_id, current_balance
from ABP_MAIN.TRANSIT_ACCOUNT
where CURRENT_BALANCE < -2500;

select *
from ABP_MAIN.JOURNAL_ENTRY
where rownum < 100
and reference_info like '%Manual%';

select entry_transaction_dtm +11/24 as day
from abp_main.trip
where trip_id = 3679964
;

select *
from abp_main.trip
where TRANSIT_ACCOUNT_ID = 100004946289
;

select *
from abp_main.trip
where TRANSIT_ACCOUNT_ID = 100004946289
order by ENTRY_TRANSACTION_DTM desc;

select *
from ABP_MAIN.BANKCARD
where 
rownum < 25
--and PG_CARD_ID is not NULL
and MASTER_PG_CARD_TOKEN = 4246
;

select *
from ABP_MAIN.TOKEN_INFO
where 
rownum < 25
and TOKEN_ID = 4115
--and TRANSIT_ACCOUNT_ID = 110000034972
;