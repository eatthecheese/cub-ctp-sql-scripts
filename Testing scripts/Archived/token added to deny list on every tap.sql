define timezone_mod = 10;
select nlh.negativelistid, nlh.tokenid, nlh.listaction, nlh.statuschangeddtm + &timezone_mod/24, nlh.emvinserteddtm
from emv.ctp_negative_list_history nlh
where tokenid = 1347146
order by nlh.tokenid, nlh.STATUSCHANGEDDTM;

select negative_list_id, token_id, list_action, status_changed_dtm + 10/24
from abp_main.ctp_negative_list_history
where token_id = 973602
order by status_changed_dtm asc
;

select *
from ABP_MAIN.TRANSIT_ACCOUNT_X_TOKEN
where token_id = 897910
;

select *
from ABP_MAIN.TRANSIT_ACCOUNT_X_TOKEN
where TRANSIT_ACCOUNT_ID = 100005723687
;

select *
from ABP_MAIN.VIOLATION
--where TOKEN_ID = 875151
where rownum < 100
;

select *
from EMV.LOCALE
where LOCALEID = '167'
;

select * from abp_main.current_negative_list where token_digest is null;

select nl.negative_list_id, nl.token_id, nl.list_action, nl.status_changed_dtm + 10/24, nl.TRANSIT_ACCOUNT_ID, nl.KEY_STORAGE_ID
from abp_main.negative_list nl
where nl.token_id in ('908259', '1483166', '314221');

select nl.negative_list_id, nl.token_id, nl.list_action, nl.status_changed_dtm + 10/24, nl.TRANSIT_ACCOUNT_ID, nl.KEY_STORAGE_ID
from abp_main.negative_list nl
where nl.KEY_STORAGE_ID 
;

desc abp_main.neg_list_sequence_nbr;

select * from abp_main.current_negative_list where token_id = 1051617;

select * from ABP_MAIN.TOKEN_STATUS_HISTORY 
where TOKEN_ID in ('908259'
)
;

define testtime = TO_DATE('30/MAY/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS');
define endtime = TO_DATE('31/MAY/2019 04:00:00', 'DD/MM/YYYY HH24:MI:SS');
define timezone_mod = 10;
select tsh.TOKEN_STATUS_HISTORY_ID, tsh.token_id, tsh.token_status_id, tsh.source, tsh.reason, tsh.note, tsh.reason_code, tsh.reference_id, tsh.inserted_dtm + &timezone_mod/24, tsh.updated_dtm + &timezone_mod/24,
axt.transit_account_id
from ABP_MAIN.TOKEN_STATUS_HISTORY tsh
join ABP_MAIN.TRANSIT_ACCOUNT_X_TOKEN axt
on tsh.token_id = axt.token_id
where 
tsh.INSERTED_DTM + &timezone_mod/24 >= &testtime + 4/24
and tsh.INSERTED_DTM + &timezone_mod/24 < &testtime + 1 + 4/24
--and REASON = 'AcctMgmtWebService.Close'
and tsh.token_status_id = 2
order by tsh.inserted_dtm
;

with status_history as (
select tsh.token_status_history_id, tsh.token_id, tsh.token_status_id, tsh.source, tsh.reason, tsh.note, tsh.reason_code, tsh.reference_type_id,
tsh.reference_id, tsh.inserted_dtm + 10/24, tsh.updated_dtm + 10/24
from abp_main.current_negative_list cnl
join abp_main.token_status_history tsh
on cnl.token_id = tsh.token_id
where cnl.token_digest is null
and tsh.token_status_id = 2
order by tsh.inserted_dtm asc
)
select axt.transit_account_id, sh.*
from status_history sh
join ABP_MAIN.TRANSIT_ACCOUNT_X_TOKEN axt
on sh.token_id = axt.token_id
;