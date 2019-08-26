with StartDate as (
    select 
    --AN ARBITRARY TEST DATE
        TO_DATE('15/APR/2019 00:00:00') StartDate
    from dual
), EndDate as (
    select 
        TO_DATE('30/JUN/2019 00:00:00') EndDate
    from dual
)
select *
from cpa.CPA_SETTLEMENT_FILE_SEQUENCE
where 
CREATED_DTM >=(SELECT * FROM StartDate) +4/24
and CREATED_DTM <=(SELECT * FROM EndDate) +4/24
order by CREATED_DTM desc
;

-- CPA EVENT LOG for settlement files
with StartDate as (
    select 
    --AN ARBITRARY TEST DATE
        TO_DATE('31/JUL/2019 00:00:00') StartDate
    from dual
), EndDate as (
    select 
        TO_DATE('09/AUG/2019 00:00:00') EndDate
    from dual
)
select *
from CPA.EVENT_LOG
where 
JOB_START_DTM >=(SELECT * FROM StartDate) +4/24
and JOB_START_DTM <=(SELECT * FROM EndDate) +4/24
--and BANK_CLIENT_NAME = 'mpgs' -- MPGS ONLY
order by JOB_START_DTM desc
;

-- GET THE JOB RUN LENGTH IN THE CPA EVENT LOG
define TestDate = TO_DATE('15/MAY/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
select EVENT_SEQUENCE_NBR, JOB_START_DTM, JOB_END_DTM, 
    (cast(JOB_END_DTM as TIMESTAMP) - cast(JOB_START_DTM as TIMESTAMP)) "Job time", 
    NOTES, MIN_SETTLEMENT_DTM, MAX_SETTLEMENT_DTM, TOTAL_COUNT, TOTAL_AMOUNT, BANK_CLIENT_NAME, INSERTED_DTM 
from cpa.event_log
--where rownum < 100
where JOB_START_DTM >= &TestDate + 4/24
order by event_sequence_nbr desc
;

with StartDate as (
    select 
    --AN ARBITRARY TEST DATE
        TO_DATE('28/MAY/2019 00:00:00') StartDate
    from dual
), EndDate as (
    select 
        TO_DATE('29/MAY/2019 00:00:00') EndDate
    from dual
)
select sum(I004_AMOUNT_TRANSACTION)
from CPA.CONFIRMATION
where 
CREDIT_CARD_TYPE_ID = 3
and MSG_DTM >= (SELECT * FROM StartDate) +4/24
and MSG_DTM <= (SELECT * FROM EndDate) +4/24
;

-- FIND A CONFIRMATION IN CPA BY RRN
select * from cpa.confirmation
where i037_retrieval_reference_num in CONCAT('0000', '45113044');
------------------------------------

select * from cpa.confirmation
where i037_retrieval_reference_num in ('000061588982'
);

select MSG_DTM, MSG_SETTLEMENT_STATUS, PAN_PARTIAL, I004_AMOUNT_TRANSACTION, I004_AMOUNT_TRANSACTION_ORIG, I037_RETRIEVAL_REFERENCE_NUM 
from CPA.CONFIRMATION 
where PAN_DIGEST = 'D314F736094EA53B2BD56E64D02DDDFAB71C130DEFFEB95304A7B3ECF2C5CC41'
order by MSG_DTM desc;

select i011_system_trace_audit_number, i037_retrieval_reference_num from cpa.confirmation
where i011_system_trace_audit_number in
(245993);

select * from cpa.confirmation
where i011_system_trace_audit_number = 244981;

select pan_partial, msg_settlement_status, i004_amount_transaction, i004_amount_transaction_orig, i007_transmission_dtm, i037_retrieval_reference_num, i039_response_code, merchant_id, confirmation_type
from cpa.confirmation
where i037_retrieval_reference_num in ('000059571608');

select api_request_log_id, request_timestamp, response_timestamp, method_name, retrieval_reference_num, pan_digest, inserted_dtm
from CPA.api_request_log
where retrieval_reference_num in ('000059694010',
'000059677557',
'000059566930')
order by retrieval_reference_num asc;

select * from CPA.api_request_log
where retrieval_reference_num = '000022583851';