select 
    transit_account_id
    ,activity_dtm+11/24
    ,current_balance
from abp_main.transit_account 
where current_balance < 0 
and account_status_id = 1 
and activity_dtm+11/24 < trunc(sysdate,'DD')+4/11 
;