desc emv.grrcn_txn;


/* QUERY TO FIND ALL TRANSACTIONS IN THE GRRCN FILE FOR A GIVEN DAY
*/
select amex_txns.TXNID, amex_txns.PAYMENTDATE, amex_txns.BUSINESSSUBMISSIONDATE, amex_txns.AMEXPROCESSINGDATE, amex_txns.TRANSACTIONAMT, amex_txns.TRANSACTIONDATE,
amex_txns.TRANSACTIONTIME, amex_txns.TRANSACTIONID, amex_txns.APPROVALCODE, amex_txns.ALLOCATEDDATE
from EMV.GRRCN_TXN amex_txns
where
amex_txns.ALLOCATEDDATE = TO_DATE('22/MAR/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
order by amex_txns.TRANSACTIONTIME desc
;

/* QUERY TO FIND TRANSACTION AMOUNTS FROM THE GRRCN FILE ON A GIVEN DAY
*/
define TestDate = TO_DATE('01/JAN/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
--define EndDate = TO_DATE('08/FEB/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
select
    ALLOCATEDDATE as "GRRCN received on",
    count(*), 
    SUM (TRANSACTIONAMT) * 0.01 "Total Txn Amt",
    MIN (TRANSACTIONTIME) "First Txn time",
    MAX (TRANSACTIONTIME) "Last Txn time"
from EMV.GRRCN_TXN
where 
    ALLOCATEDDATE >= &TestDate
--    and ALLOCATEDDATE <= &TestDate + 31
    and ALLOCATEDDATE < sysdate
group by ALLOCATEDDATE
order by ALLOCATEDDATE asc
;

/*THIS QUERY RETURNS THE SETTLED AMOUNT FOR VISA/MC TXNS FOR A GIVEN SUMMARY PERIOD IN CPA.
*/
desc emv.confirmation;
with StartDate as (
    select 
    --AN ARBITRARY TEST DATE
        TO_DATE('06/JUL/2019 00:00:00') testDate
    from dual
), EndDate as (
    select 
        TO_DATE('07/JUL/2019 00:00:00') otherdate
    from dual
)
select 
SUM(I004AMOUNTTRANSACTION) * 0.01 as CPA_SETTLEDAMT,
COUNT(I004AMOUNTTRANSACTION),
MIN(MSGDTM) as "First settlement txn created",
MAX(MSGDTM) as "Last settlement txn created"
--*
from emv.confirmation
where MSGSETTLEMENTSTATUS in (4,6)
    and CREDITCARDTYPEID in (1,2) -- VISA/MC only
    and MSGDTM >= (SELECT * FROM StartDate) +4/24 
    and MSGDTM <= (SELECT * FROM EndDate) +4/24 
order by MSGDTM asc
;