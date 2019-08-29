alter session set current_schema = abp_main;

select *
from all_tables
where owner = 'ABP_MAIN'
;

select *
from operator;

select *
from all_tab_columns
where table_name = 'OPERATOR';

update abp_main.operator
set HOLD_THRESHOLD_AMT = 480, DEFAULT_PEAK_FARE = 480, DEFAULT_OFFPEAK_FARE = 480
where OPERATOR_ID = 10
;