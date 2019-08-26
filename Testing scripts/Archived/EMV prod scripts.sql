select *
from Abp_staging.FLEX_LOAD_LOG
where 
extract_dtm like '%20/MAY/19%'
and successful_flag <> 0
order by extract_dtm desc
;

select *
from ABP_STAGING.FLEX_SETTINGS
;


select tr.* --tripid, journeyid
from emv.trip tr
where not exists ( select 1 from emv.JOURNEY  t where t.JourneyID= tr.JourneyID)
and tr.JourneyID is not null;

select SUM(I004AMOUNTTRANSACTION), I017CAPTUREDATE from EMV.confirmation where CREDITCARDTYPEID in (1,2) and MSGSETTLEMENTSTATUS in (4,6) and I017CAPTUREDATE in (20190528,20190527) group by (I017CAPTUREDATE)
;

select *
from EMV.JOURNAL_ENTRY_TYPE;

-------------
-- SANDBOX --
-------------

-- Find all bankcard payments without matching journal entries in ABP
select *
from emv.bankcard_payment where PGRETRIEVALREFNBR = '000059566930'
;

define TestDate = TO_DATE('5/JUL/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
define timezone_mod = 10;
select bp.pgsettlementdtm + 10/24, bp.*, je.*
from emv.bankcard_payment bp
left outer join emv.journal_entry je
on je.bankcardpaymentid = bp.bankcardpaymentid
where 
bp.PGSETTLEMENTDTM + &timezone_mod/24 >= &TestDate + 4/24
and bp.PGSETTLEMENTDTM + &timezone_mod/24 < &TestDate + 1 + 4/24
--and bp.PGRETRIEVALREFNBR = '000059566930'
--and je.JOURNALENTRYID = null
;

-- QUERY TO FIND TRIP DATA FOR A GIVEN DAY
----------------------------------------------------------------------
define TestDate = TO_DATE('24/MAY/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
define EndDate = TO_DATE('25/MAY/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
define timezone_mod = 10;
select 
--*
TRIPID, TRANSITACCOUNTID, TOKENID, TAPCOUNT, ENTRYTRANSACTIONDTM + &timezone_mod/24 "Entry time", EXITTRANSACTIONDTM + &timezone_mod/24 "Exit time", ENTRYSTOPID, EXITSTOPID, JOURNEYID, 
CALCULATEDFARE, FAREDUE, PAIDAMT, BANKCARDAMT, CAPAMT, INSERTEDDTM, UPDATEDDTM, EMVINSERTEDDTM
from EMV.TRIP
where 
ENTRYTRANSACTIONDTM + &timezone_mod/24 >= &TestDate + 4/24
and ENTRYTRANSACTIONDTM +&timezone_mod/24 <= &EndDate + 4/24
and TRANSITACCOUNTID = 100004320493
;
----------------------------------------------------------------------

-- FIND BANKCARD IDs 
----------------------------------------------------------------------
select tk.*, bc.*
from EMV.TOKEN tk
join EMV.BANKCARD bc
on tk.bankcardid = bc.bankcardid
where rownum < 100
--and tk.tokenid = 1140162
and bc.bankcardid in (1059612,
1058985,
439232,
1056532)
--and bc.bin = 379949
;
----------------------------------------------------------------------
----------------------------------------------------------------------

----------------------------------------------------------------------
-- FIND VARIANCES BTWN CPA CONFIRMATION AND ABP AMOUNTS GIVEN A TRANSIT ACCOUNT ID
----------------------------------------------------------------------
define TestDate = TO_DATE('04/JUL/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
--define EndDate = TO_DATE('28/FEB/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
select bp.pgsettlementamt "ABP Amount", cf.I004AMOUNTTRANSACTION "CPA Amount", cf.MSGSETTLEMENTSTATUS, bp.*, cf.*
from emv.confirmation cf
join emv.bankcard_payment bp
on cf.I037RETRIEVALREFERENCENUM = bp.PGRETRIEVALREFNBR
where cf.MSGDTM > &TestDate + 4/24
and cf.MSGDTM < &TestDate + 1 + 4/24 
and bp.TRANSITACCOUNTID = 100012734586
;

select *
from EMV.BIN_VALIDITY
order by STARTSWITH asc;

-- GIVEN A RRN
select bp.pgsettlementamt "ABP Amount", cf.I004AMOUNTTRANSACTION "CPA Amount", cf.MSGSETTLEMENTSTATUS, bp.*, cf.*
from emv.confirmation cf
left outer join emv.bankcard_payment bp
on cf.I037RETRIEVALREFERENCENUM = bp.PGRETRIEVALREFNBR
where cf.MSGDTM > &TestDate + 4/24
and cf.MSGDTM < &TestDate + 2 + 4/24 
and cf.I037RETRIEVALREFERENCENUM in (
'000059037798'
)
;

----------------------------------------------------------------------
----------------------------------------------------------------------

select *
from EMV.TOKEN
where
tokenid in (1059612,
1058985,
439232,
1056532)
;

-- QUERY TO FIND ALL TRANSACTIONS IN THE MRF FILE FOR A GIVEN DAY
----------------------------------------------------------------------
with StartDate as (
    select 
    --AN ARBITRARY ALLOCATED DATE
        TO_DATE('06/JUL/2019 00:00:00') testDate
    from dual
)
select 
*
from EMV.MRF_TRANSACTION_DETAIL
where 
ALLOCATEDDATE = (SELECT * FROM StartDate)
and TRANSACTIONTYPE = 'PURCHASE-F'
order by TRANSACTIONTIME desc -- TRANSACTIONTIME corresponds to time when txn was sent to CBA
;
----------------------------------------------------------------------

-- QUERY TO FIND ALL TRANSACTIONS IN THE GRRCN FILE FOR A GIVEN DAY
----------------------------------------------------------------------
select *
from EMV.GRRCN_TXN
where
ALLOCATEDDATE = TO_DATE('30/JUL/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
order by TRANSACTIONTIME desc
;
----------------------------------------------------------------------

-- QUERY TO FIND TRANSACTION AMOUNTS FROM THE GRRCN FILE ON A GIVEN DAY
define TestDate = TO_DATE('30/JUL/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
--define EndDate = TO_DATE('08/FEB/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
desc emv.grrcn_txn;
select
    --*
    ALLOCATEDDATE,
    count(*), 
    SUM (TRANSACTIONAMT) * 0.01 "Total Txn Amt",
    MIN (TRANSACTIONTIME) "First Txn time",
    MAX (TRANSACTIONTIME) "Last Txn time",
    min (AMEXPROCESSINGDATE),
    max (AMEXPROCESSINGDATE),
    min (BUSINESSSUBMISSIONDATE)
from EMV.GRRCN_TXN
where 
    ALLOCATEDDATE >= &TestDate
    and ALLOCATEDDATE <= &TestDate + 30
group by ALLOCATEDDATE
order by ALLOCATEDDATE desc
;
----------------------------------------------------------------------

-- QUERY TO FIND TRANSACTION AMOUNTS FROM THE MRF FILE ON A GIVEN DAY
----------------------------------------------------------------------
with StartDate as (
    select 
    --THIS IS THE ALLOCATED DATE
        TO_DATE('05/JUL/2019 00:00:00') testDate
    from dual
), EndDate as (
    select 
        TO_DATE('08/JUL/2019 00:00:00') otherdate
    from dual
)
select 
--*
    ALLOCATEDDATE, SUM(TOTALAMOUNT)* 0.01 as MRF_SETTLEDAMT,
    COUNT(TOTALAMOUNT),
    MIN(TRANSACTIONTIME) "First settlement txn sent",
    MAX(TRANSACTIONTIME) "Last settlement txn sent"
from EMV.MRF_TRANSACTION_DETAIL
where 
    ALLOCATEDDATE >= (SELECT * FROM StartDate)
    and ALLOCATEDDATE <= (SELECT * FROM EndDate)
    and TRANSACTIONTYPE = 'PURCHASE-F'
group by ALLOCATEDDATE
order by ALLOCATEDDATE asc
;
----------------------------------------------------------------------

-- THIS QUERY RETURNS THE SETTLED AMOUNT FOR VISA/MC TXNS FOR A GIVEN SUMMARY PERIOD IN CPA.
----------------------------------------------------------------------
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
----------------------------------------------------------------------

select * from EMV.tap
where 
tapid in (5258901, 5259177);

select * from EMV.trip
where tripid = 2673390;

select * from EMV.journal_entry
where journalentryid = 3179481;

select nl.*, tk.bankcardid, tk.tokenpartial from EMV.NEGATIVE_LIST nl
join EMV.TOKEN tk
on  nl.tokenid = tk.tokenid
where nl.statuschangeddtm like '%15/MAR/19%'
and nl.listaction = 'A'
;

select nl.*, bc.bin, bc.cardpartial from EMV.NEGATIVE_LIST nl
join EMV.BANKCARD bc
on  nl.tokenid = bc.tokenid
where nl.statuschangeddtm like '%20/MAR/19%'
and nl.listaction = 'A'
;

select * from EMV.TOKEN
where tokenid in ('23569', '609535')
;

select * from EMV.BANKCARD
where tokenid in ('23569', '609535')
;

select * from EMV.NEGATIVE_LIST_HISTORY
where rownum < 100;
----------------------------------------------------------------------------------------------------------------------------------

-- CTP Deny List KPI reporting
-- Case 1: Check if Tap was denied but should have been approved
select tap.tapid, tap.transactiondtm, tap.deviceid, tap.stopid, tap.tokenid, tap.transitaccountid, tap.tapstatusdescription, tap.neglistcurrentversion, tap.neglistasofdtm
from EMV.tap tap
where 
tapid = 5190605
and tap.tapstatusdescription = 'Device Risk Assessment Failed'
and tap.deviceid not in ('ABP00001');

-- Case 2: Check if Tap was approved but should have been denied
select tap.tapid, tap.transactiondtm, tap.deviceid, tap.stopid, tap.tokenid, tap.transitaccountid, tap.tapstatusdescription, tap.neglistcurrentversion, tap.neglistasofdtm
from EMV.tap tap
where 
tapid = 5288781
and tap.tapstatusdescription = 'Device Approved'
and tap.deviceid not in ('ABP00001');

select *
from EMV.CTP_NEGATIVE_LIST_DEVICE_LOG
order by dtm desc;

select *
from EMV.CTP_NEGATIVE_LIST_DEVICE_LOG
order by dtm desc;

-- Appendix A: Check for the token in negative list history
select *
from EMV.ctp_negative_list_history
where tokenid = 513981
order by negativelistid desc;

select *
from EMV.ctp_negative_list
where tokenid = 513981
order by negativelistid desc;

select currentbalance
from emv.transit_account
where transitaccountid = 100004716898;

select trunc(EMV.CTS_UTILS_01.local_dtm(t.TRANSACTIONDTM)) , count(*)
FROM emv.tap t
where not exists ( select 1
FROM emv.trip O
where t.tripid = O.tripid
)
and tripid is not null
and trunc(EMV.CTS_UTILS_01.local_dtm(t.TRANSACTIONDTM)) >= to_date('01-Mar-2019')
group by trunc(EMV.CTS_UTILS_01.local_dtm(t.TRANSACTIONDTM)) ;

select *
from emv.tap t
where not exists ( select 1
FROM emv.trip O
where t.tripid = O.tripid
)
and tripid is not null
and trunc(EMV.CTS_UTILS_01.local_dtm(t.TRANSACTIONDTM)) = to_date('11-Apr-2019');

select *
from emv.trip
where tripid = 2687147;
----------------------------------------------------------------------------------------------------------------------------------

-- CTP Txn Proc KPI reporting, part (b)
select tap.tapid, tap.transitaccountid, tap.transactiondtm, tap.inserteddtm, tap.tapstatusdescription, trip.tripid, je.journalentryid, bp.bankcardpaymentid, bp.pgretrievalrefnbr, bp.inserteddtm as BP_OPENEDTIME
from EMV.tap 
join EMV.trip trip on tap.tapid = trip.entrytapid -- Joins entry taps only; does not work for unstarted exit taps
inner join EMV.journal_entry je on trip.tripid = je.tripid
inner join EMV.bankcard_payment bp on bp.bankcardpaymentid = je.bankcardpaymentid
where tap.tapid in ('5220134', '5258901', '5316805')
and tap.tapstatusdescription = 'Device Approved'
and je.bankcardpaymentid is not null
;


select * from emv.journal_entry je
where tripid  = 2673390
and bankcardpaymentid is not null;

select * from emv.bankcard_payment bp
where rownum < 100;

select *
from emv.confirmation
where 
i037retrievalreferencenum = '000047803258';

select * from emv.confirmation cf
where cf.I037RETRIEVALREFERENCENUM = '000047614265'
;

-- ALL records with different amounts between ABP and CPA, pre-7/Apr/2019
select bp.INSERTEDDTM +11/24,bp.bankcardpaymentid,bp.transitaccountid,bp.PGRETRIEVALREFNBR,bp.PGSETTLEMENTAMT as ABP_Amount,c.I004AMOUNTTRANSACTION as CPA_Amount from emv.bankcard_payment bp
join emv.confirmation c on bp.pgretrievalrefnbr = c.I037RETRIEVALREFERENCENUM
where bp.PGSETTLEMENTAMT != c.I004AMOUNTTRANSACTION
order by bankcardpaymentid desc
;

-- ALL records with different amounts between ABP and CPA, post-7/Apr/2019
select bp.INSERTEDDTM +10/24,bp.bankcardpaymentid,bp.transitaccountid,bp.PGRETRIEVALREFNBR,bp.PGSETTLEMENTAMT as ABP_Amount,c.I004AMOUNTTRANSACTION as CPA_Amount from emv.bankcard_payment bp
join emv.confirmation c on bp.pgretrievalrefnbr = c.I037RETRIEVALREFERENCENUM
where bp.PGSETTLEMENTAMT != c.I004AMOUNTTRANSACTION
and bp.INSERTEDDTM +10/24 < sysdate -1
order by bankcardpaymentid desc
;

select * from EMV.mrf_file where merchantfileid > 22500 order by merchantfileid desc;

-- Records with different amounts between ABP and CPA; yesterday
select bp.INSERTEDDTM+11/24 as dateofrecord,bp.bankcardpaymentid,bp.transitaccountid,bp.PGRETRIEVALREFNBR,bp.PGSETTLEMENTAMT as ABP_Amount,c.I004AMOUNTTRANSACTION as CPA_Amount from emv.bankcard_payment bp
join emv.confirmation c on bp.pgretrievalrefnbr = c.I037RETRIEVALREFERENCENUM
where bp.PGSETTLEMENTAMT != c.I004AMOUNTTRANSACTION
and bp.inserteddtm +11/24 < trunc(sysdate,'DD')
order by bankcardpaymentid desc
;

-- Count of RRNs with different amounts between ABP and CPA for Solarwinds; yesterday
select count (bp.PGRETRIEVALREFNBR) from emv.bankcard_payment bp
join emv.confirmation c on bp.pgretrievalrefnbr = c.I037RETRIEVALREFERENCENUM
where bp.PGSETTLEMENTAMT != c.I004AMOUNTTRANSACTION
and bp.inserteddtm +11/24 < trunc(sysdate,'DD')
and bp.inserteddtm +11/24 >= trunc(sysdate - 1,'DD')
order by bankcardpaymentid desc
;

-- CPA vs. ABP transaction settlement amount discrepancies report
-- Version 1.0 initial revision

-- Script 1.0 Count of RRNs with different amounts between ABP and CPA + Amounts over/undercharged; 
select count (bp.PGRETRIEVALREFNBR) as Affected_transactions, sum (bp.PGSETTLEMENTAMT) as Amount_undercharged, sum (c.I004AMOUNTTRANSACTION) as Amount_overcharged from emv.bankcard_payment bp
join emv.confirmation c on bp.pgretrievalrefnbr = c.I037RETRIEVALREFERENCENUM
where bp.PGSETTLEMENTAMT != c.I004AMOUNTTRANSACTION
and bp.inserteddtm +11/24 < trunc(sysdate -7,'DD')
and bp.inserteddtm +11/24 >= trunc(sysdate - 1 -7,'DD')
order by bankcardpaymentid desc
;
-- Script 2. Details of RRNs with different amounts between ABP and CPA; 
select bp.INSERTEDDTM+10/24 as dateofrecord,bp.bankcardpaymentid,bp.transitaccountid,bp.PGRETRIEVALREFNBR,bp.PGSETTLEMENTAMT as ABP_Amount,c.I004AMOUNTTRANSACTION as CPA_Amount from emv.bankcard_payment bp
join emv.confirmation c on bp.pgretrievalrefnbr = c.I037RETRIEVALREFERENCENUM
where bp.PGSETTLEMENTAMT != c.I004AMOUNTTRANSACTION
-- BELOW SETS THE TRANSACTION DATE TO LOOK FOR. CURRENTLY SET TO YESTERDAY.
and bp.inserteddtm +10/24 < trunc(sysdate - 7,'DD')
and bp.inserteddtm +10/24 >= trunc(sysdate - 1 - 7,'DD')
order by bankcardpaymentid desc
;

-- Show all report codes and their file names which need to be run
select * from emv.ctp_reports where enabled = 'YES';

alter session set current_schema = EMV;

-- CTP002 Report: Taps without Trips report
SELECT
  TAPID,
  DEVICEID,
  TRANSACTIONID,
  EMV.CTS_UTILS_01.local_dtm(TRANSACTIONDTM) TRANSACTIONDTM,
  SEQUENCE,
  TAP.TOKENID,
  LOCALE.DESCRIPTION STOP,
  case when ENTRYEXITID = 11 then 'EntryOrExit'
       when ENTRYEXITID = 12 then 'Entry'
       when ENTRYEXITID = 13 then 'Exit'
       when ENTRYEXITID = 14 then 'Inspection'
                             else 'Other' end ENTRYEXIT,
  case when TAPTYPEID = 1 then 'Tap'
       when TAPTYPEID = 2 then 'Missing Tap'
       when TAPTYPEID = 3 then 'Reserved'
       when TAPTYPEID = 4 then 'MissingTapForcedEntry'
       when TAPTYPEID = 5 then 'MissingTapForcedExit'
                          else 'Other' end TAPPTYPE,
  case when UNMATCHEDFLAG =  1 then 'Ignored'
       when UNMATCHEDFLAG =  2 then 'Unmatched'
       when UNMATCHEDFLAG =  3 then 'Matched'
       when UNMATCHEDFLAG =  4 then 'PendingVoid '
       when UNMATCHEDFLAG =  5 then 'Void'
       when UNMATCHEDFLAG =  6 then 'PendingJourneyExtension'
                               else 'Other' end UNMATCHEDFLAG,
  TAPSTATUSDESCRIPTION,
  TAP.TRANSITACCOUNTID,
  BANKCARD.Bin||'-'||substr(BANKCARD.CardPartial,2,3) CARDNUMBER,
  op.operatorname OPERATOR,
  op.etsoperatorid OPERATOR_ID

FROM EMV.TAP INNER JOIN EMV.TAP_STATUS on TAP.TAPSTATUSID = TAP_STATUS.TAPSTATUSID
         INNER JOIN EMV.LOCALE ON TAP.STOPID = LOCALE.LOCALEID
         INNER JOIN EMV.TOKEN on TAP.TOKENID = TOKEN.TOKENID
         INNER JOIN EMV.BANKCARD on TOKEN.BANKCARDID = BANKCARD.BANKCARDID
         LEFT JOIN EMV.ets_operator op               on TAP.STOPID = op.NLC
WHERE TRIPID IS NULL
  AND TAP_STATUS.GOODFLAG = 1
  AND trunc(EMVINSERTEDDTM - 4/24) >= trunc(sysdate-1 -97)
  AND trunc(EMVINSERTEDDTM - 4/24) < trunc(sysdate - 97)
;


-- CTP001 report: CTP Uncleared Accounts
select case when CURRENTBALANCE < 0 then 'DEBTOR'
                                  else 'CREDITOR' end Type,
     TransitAccountId,
     CURRENTBALANCE/100 StoredValueAmt$,
     EMV.CTS_UTILS_01.local_dtm(OverdrawnDtm) Overdrawn_Dtm,
     EMV.CTS_UTILS_01.local_dtm(UncollectibleDtm) UncollectibleDtm,
     EMV.CTS_UTILS_01.local_dtm(ZeroBalanceDtm) ZeroBalanceDtm,
     EMV.CTS_UTILS_01.local_dtm(ActivityDtm) ActivityDtm,
     trunc(sysdate) - trunc(EMV.CTS_UTILS_01.local_dtm(OverDrawnDTM)) DaysOverdrawn
from EMV.TRANSIT_ACCOUNT
where CURRENTBALANCE <> 0
order by case when StoredValueAmt < 0 then 'DEBTOR'
                                  else 'CREDITOR' end desc,
     TRANSIT_ACCOUNT.OverdrawnDtm
;

-- CTP500 Report
select TransactionDate Transaction_Date,
          sum(EntryTapCount) Entry_Tap_Count,
          sum(ExitTapCount) Exit_Tap_Count,
          sum(TapTripCount) Tap_Trip_Count,
          sum(TotalTripCount) Total_Trip_Count, 
          sum(ZeroPricedTripCount) Zero_Priced_Trip_Count,
          sum(PricedTripCount) Priced_Trip_Count, 
          sum(UnPaidTripCount) UnPaid_Trip_Count, 
          sum(PaidTripCount) Paid_Trip_Count, 
          sum(FareDue)/100 Fare_Due,
          sum(PaidAmt)/100 Paid_Amt,
          sum(BankcardAmt)/100 Bankcard_Amt,   
          sum(StoredValueAmt)/100 Stored_Value_Amt,
          sum(WriteOffAmt)/100 Write_Off_Amt,
          sum(TripPaymentCount) Trip_Payment_Count,
          sum(TripPaymentAmt)/100 Trip_Payment_Amt,
          sum(TripPaymentPendingCount) Trip_Payment_Pending_Count,
          sum(TripPaymentPendingAmt)/100 Trip_Payment_Pending_Amt,
          sum(TripPaymentReconciledCount) Trip_Payment_Reconciled_Count,
          sum(TripPaymentReconciledAmt)/100 Trip_Payment_Reconciled_Amt,
          sum(DebtPaymentCount) Debt_Payment_Count,
          sum(DebtPaymentAmt)/100 Debt_Payment_Amt,
          sum(DebtPaymentPendingCount) Debt_Payment_Pending_Count,
          sum(DebtPaymentPendingAmt)/100 Debt_Payment_Pending_Amt,
          sum(DebtPaymentReconciledCount) Debt_Payment_Reconciled_Count,
          sum(DebtPaymentReconciledAmt)/100 Debt_Payment_Reconciled_Amt,
          Sum(DebtorAccountsCount) Debtor_Accounts_Count,
          Sum(DebtorAccountsAmt)/100 Debtor_Accounts_Amt,
          sum(CreditorAccountsCount) Creditor_Accounts_Count,
          sum(CreditorAccountsAmt)/100 Creditor_Accounts_Amt
          
    from 
 (
 select   TransactionDate TransactionDate,
          sum(EntryTapCount) EntryTapCount,
          sum(ExitTapCount) ExitTapCount,
          sum(TapTripCount) TapTripCount,
          sum(TotalTripCount) TotalTripCount, 
          sum(ZeroPricedTripCount) ZeroPricedTripCount,
          sum(PricedTripCount) PricedTripCount,
          sum(UnPaidTripCount) UnPaidTripCount, 
          sum(PaidTripCount) PaidTripCount, 
          sum(FareDue)FareDue,
          sum(PaidAmt)PaidAmt,
          sum(BankcardAmt)BankcardAmt,   
          sum(StoredValueAmt)StoredValueAmt,
          sum(WriteOffAmt)WriteOffAmt,
          sum(TripPaymentCount) TripPaymentCount,
          sum(TripPaymentAmt) TripPaymentAmt,
          sum(TripPaymentPendingCount) TripPaymentPendingCount,
          sum(TripPaymentPendingAmt) TripPaymentPendingAmt,
          sum(TripPaymentReconciledCount) TripPaymentReconciledCount,
          sum(TripPaymentReconciledAmt)TripPaymentReconciledAmt,
          sum(DebtPaymentCount) DebtPaymentCount,
          sum(DebtPaymentAmt) DebtPaymentAmt,
          sum(DebtPaymentPendingCount) DebtPaymentPendingCount,
          sum(DebtPaymentPendingAmt)DebtPaymentPendingAmt,
          sum(DebtPaymentReconciledCount) DebtPaymentReconciledCount,
          sum(DebtPaymentReconciledAmt) DebtPaymentReconciledAmt,
          0 DebtorAccountsCount,
          0 DebtorAccountsAmt,
          0 CreditorAccountsCount,
          0 CreditorAccountsAmt
     from EMV.DAILY_SUMMARY_V
    where TransactionDate >= trunc(sysdate -30) 
      and TransactionDate < trunc(sysdate) 
    group by TransactionDate
union all 
    select snapshotdate TransactionDate,
          0 EntryTapCount,
          0 ExitTapCount,
          0 TapTripCount,
          0 TotalTripCount, 
          0 ZeroTripCount,
          0 PricedTripCount, 
          0 UnPaidTripCount, 
          0 PaidTripCount, 
          0 FareDue,
          0 PaidAmt,
          0 BankcardAmt,   
          0 StoredValueAmt,
          0 WriteOffAmt,
          0 TripPaymentCount,
          0 TripPaymentAmt,
          0 TripPaymentPendingCount,
          0 TripPaymentPendingAmt,
          0 TripPaymentReconciledCount,
          0 TripPaymentReconciledAmt,
          0 DebtPaymentCount,
          0 DebtPaymentAmt,
          0 DebtPaymentPendingCount,
          0 DebtPaymentPendingAmt,
          0 DebtPaymentReconciledCount,
          0 DebtPaymentReconciledAmt,
          0 DebtorAccountsCount,
          0 DebtorAccountsAmt,
          count(TransitAccountID) CreditorAccountsCount,
          sum(StoredValueAmt) CreditorAccountsAmt
     from EMV.UNCLEARED_ACCOUNT_SNAPSHOT_V
     where ACCOUNTTYPE = 'CREDITOR'
     union all
    
    select snapshotdate TransactionDate,
          0 EntryTapCount,
          0 ExitTapCount,
          0 TapTripCount,
          0 TotalTripCount, 
          0 ZeroTripCount,
          0 PricedTripCount, 
          0 UnPaidTripCount, 
          0 PaidTripCount, 
          0 FareDue,
          0 PaidAmt,
          0 BankcardAmt,   
          0 StoredValueAmt,
          0 WriteOffAmt,
          0 TripPaymentCount,
          0 TripPaymentAmt,
          0 TripPaymentPendingCount,
          0 TripPaymentPendingAmt,
          0 TripPaymentReconciledCount,
          0 TripPaymentReconciledAmt,
          0 DebtPaymentCount,
          0 DebtPaymentAmt,
          0 DebtPaymentPendingCount,
          0 DebtPaymentPendingAmt,
          0 DebtPaymentReconciledCount,
          0 DebtPaymentReconciledAmt,
          count(TransitAccountID) DebtorAccountsCount,
          sum(StoredValueAmt) DebtorAccountsAmt,
          0 CreditorAccountsCount,
          0 CreditorAccountsAmt
     from EMV.UNCLEARED_ACCOUNT_SNAPSHOT_V
    where ACCOUNTTYPE = 'DEBTOR'
     )
     group by TransactionDate
     order by TransactionDate
;

-- CTP004 Report Payments without Settlements
 SELECT trunc(je.EmvInsertedDtm - 4.5/24) SummaryPeriod,
        'ABP ONLY' PAYMENT_SRC,
         null PAYMENTID,
         bp.BANKCARDPAYMENTID,
         null SETTLEMENTDATE,
         null CAICID, 
         null TERMINALID,
         null SYSTEMTRACEAUDITNUMBER,
         TO_NUMBER(tav.STAN_AUTH,'999999') SYSTEMTRACEAUDITNUMBERAUTH,
         tav.rrn RETRIEVALREFERENCENBR,
         tav.receipt RECEIPT,
         bp.PGAUTHORIZATIONID AUTHORIZATIONID,
         bc.Bin||'-'||substr(bc.CardPartial,2,4) CARDNUMBER,
         EMV.CTS_UTILS_01.local_dtm(bp.PGSETTLEMENTDTM) TRANSACTIONDTM, -- as ABP knows it
         bp.PGSETTLEMENTAMT/100 SETTLEDAMT$,
         null ALLOCATEDDATE,
         je.journalentryid JOURNALENTRYID, 
         je.TRIPID TRIPID,
         je.TRANSITACCOUNTID TRANSITACCOUNTID      
    FROM EMV.journal_entry je
    JOIN EMV.bankcard_payment bp on je.bankcardpaymentid = bp.bankcardpaymentid
    LEFT JOIN EMV.bankcard bc on bp.BANKCARDID = bc.BANKCARDID
    LEFT JOIN EMV.transaction_auth_v tav on bp.PGRETRIEVALREFNBR = tav.rrn
    left join emv.confirmation co on co.I037RETRIEVALREFERENCENUM =  bp.PGRETRIEVALREFNBR
   WHERE 1=1
   and (je.multipursetypeid = 4 and je.multipurseusageid = 1 )
   and je.EmvInsertedDtm < trunc(sysdate)  + 4.5/24 
   and bp.PGSETTLEMENTAMT <> 0
   and (bp.BANKCARDPAYMENTSTATUSID = 1   --ABP is settled
         and ( co.MSGSETTLEMENTSTATUS != 6 and co.MSGSETTLEMENTSTATUS != 4)      -- CPA Side has not settled (6 or 4 or 0 if value is $0)            
   )
   union
     SELECT EmvInsertedDtm SummaryPeriod,
        'ABP/CPA' PAYMENT_SRC,
         PAYMENTID,
         BANKCARDPAYMENTID,
         SETTLEMENTDATE,
         CAICID, 
         TERMINALID,
         SYSTEMTRACEAUDITNUMBER,
         SYSTEMTRACEAUDITNUMBERAUTH,
         RETRIEVALREFERENCENBR,
         RECEIPT,
         AUTHORIZATIONID,
         CARDNUMBER,
         TRANSACTIONDTM,
         SETTLEDAMT/100 SETTLEDAMT$,
         ALLOCATEDDATE,
         JOURNALENTRYID, 
         TRIPID,
         TRANSITACCOUNTID      
    FROM EMV.PAYMENT_PENDING
   WHERE PAYMENTID not in (SELECT PAYMENTID from EMV.RECONCILIATION_INPUT)   
ORDER BY TRANSACTIONDTM
;
-- CTP230 Report
with ta as
(select * from EMV.transaction_auth_v where receipt not like '%reversal%') -- there are 2 records per RRN for a reversal, need to filter those out to prevent doubling up journal entries
select TRUNC(je.EmvInsertedDtm - 4.5/24) SummaryPeriod,
          je.JournalEntryID,
          je.JournalEntryTypeID,
          jt.Description,
          mp.description PurseTypeDESC,
          je.multipursetypeid PURSETYPE,
          je.multipurseusageid PURSEUSAGE,
          je.ReversalFlag,
          case when je.JournalEntryTypeID = 109 and je.multipursetypeid = 4 and je.multipurseusageid = 1 and je.ReversalFlag = 0 then 'Trip Revenue - Bankcard Payment'
               when je.JournalEntryTypeID = 109 and je.multipursetypeid = 1 and je.multipurseusageid = 1 and je.ReversalFlag = 0 then 'Trip Revenue - Account Payment'
               when je.JournalEntryTypeID = 109 and je.multipursetypeid = 1 and je.multipurseusageid = 1 and je.ReversalFlag = 1 then 'Trip Reversal - Account Payment'
               when je.JournalEntryTypeID = 109 and je.multipursetypeid = 4 and je.multipurseusageid = 1 and je.ReversalFlag = 1 then 'Trip Reversal - Bankcard Payment'
               when je.JournalEntryTypeID = 108 and je.multipursetypeid = 1 and je.multipurseusageid = 1 then 'Trip Revenue - Failed Payment'
               when je.JournalEntryTypeID = 101 and je.multipursetypeid = 1 and je.multipurseusageid = 1 then 'Debt Recovery - Account Adjustment'
               when je.JournalEntryTypeID = 101 and je.multipursetypeid = 4 and je.multipurseusageid = 1 then 'Debt Recovery - Bankcard Payment'
               when je.JournalEntryTypeID = 102 and je.multipursetypeid = 1 and je.multipurseusageid = 1 and
               (je.REFERENCEINFO is null or je.REFERENCEINFO not like '%ORPA%') then 'Account Adjustment'
               when je.JournalEntryTypeID = 102 and je.multipursetypeid = 1 and je.multipurseusageid = 1 and je.REFERENCEINFO like '%ORPA%' then 'ORPA Account Adjustment'
               when je.JournalEntryTypeID = 109 and je.multipursetypeid = 5 and je.multipurseusageid = 1 then 'Price Cap Award'
               else 'default' end PostingCategory,
          je.TransactionAmt/100 TransactionAmt$,
          EMV.CTS_UTILS_01.local_dtm(je.TransactionDtm) TransactionDtm,
          je.TransitAccountID,
          je.TripID,
          tr.ENTRYTAPID,
          EMV.CTS_UTILS_01.local_dtm(tr.EntryTransactionDTM) EntryTransactionDTM,
          lo.DESCRIPTION ENTRYSTOP,
          la.description EXITSTOP,
          EMV.CTS_UTILS_01.local_dtm(tr.ExitTransactionDTM) ExitTransactionDTM,
          tr.EXITTAPID,
  case when tr.PRICINGSTATUS = 1 then 'Unpriced'
       when tr.PRICINGSTATUS = 2 then 'Priced'
       when tr.PRICINGSTATUS = 3 then 'Void'
       when tr.PRICINGSTATUS = 4 then 'Reprice'
       when tr.PRICINGSTATUS = 5 then 'Restart' END PRICINGSTATUS,
  tr.FAREDUE/100 FAREDUE$,

  --heavy rail
  case when je.JournalEntryTypeID = 102 and je.multipursetypeid = 1 and je.multipurseusageid = 1 and je.REFERENCEINFO like '%ORPA%' and je.REFERENCEINFO like '%SAF%' then je.TransactionAmt/100
  else -tr.CALCULATEDFEE/100 END SAFDUE$,
  --heavy rail

  --heavy rail
  case when je.JournalEntryTypeID = 102 and je.multipursetypeid = 1 and je.multipurseusageid = 1 and je.REFERENCEINFO like '%ORPA%' and je.REFERENCEINFO not like '%SAF%' then je.TransactionAmt/100
  else -(tr.FAREDUE -tr.CALCULATEDFEE)/100 end REVENUE$,
  --heavy rail

  tr.PAIDAMT/100 PAIDAMT$,
  tr.STOREDVALUEAMT/100 STOREDVALUEAMT$,
  tr.BANKCARDAMT/100 BANKCARDAMT$,
  tr.UNPAIDAMT/100 UNPAIDAMT$,
  tr.WRITEOFFAMT/100 WRITEOFFAMT$,

  --banking data
  je.BankCardPaymentID,
  bp.PgRetrievalRefNbr,
  b.Bin||'-'||substr(b.CardPartial,2,3) CARDNUMBER,
  case
	  when ta.rrn is not null and tc.caicid is null then null		--ARQ 20376 Check if there is a auth record BUT no capture record (i.e. failed capture not Amex Direct)
	  when tc.caicid is null then co.merchantid
	  else tc.caicid
  end CAICID,
  coalesce(md1.description,md2.description,'Unknown Merchant') MERCHANT,
  case
	  when ta.rrn is not null and tc.terminalid is null then null 	--ARQ 20376 Check if there is a auth record BUT no capture record (i.e. failed capture not Amex Direct)
	  when tc.terminalid is null then co.i041cardacceptorterminalid
	  else tc.terminalid
  end TERMINALID,
  ta.STAN_AUTH AUTH_STAN,
  co.I007TRANSMISSIONDTM AUTH_DTM,
  tc.STAN_CAPTURE STAN_CAPTURE,
  case
	  when ta.rrn is not null and tc.timeofrecord is null then null	--ARQ 20376 Check if there is a auth record BUT no capture record (i.e. failed capture not Amex Direct)
	  when tc.timeofrecord is null then trunc(to_date(co.i017capturedate, 'YYYYMMDD'))
	  else tc.timeofrecord
	  end CAPTURE_DTM,
  ta.RECEIPT as RECEIPT,
  je.purseloadid,
  op_orpa.locationname ORPA_LOCATION,

      CASE
        when je.journaltype in ('ORPA','ORPA-SAF') then op_orpa.operatorname
        when op_nr.transportmode in ('FERRY', 'LIGHT RAIL') then op_nr.operatorname
        when op_nr.transportmode in ('RAIL') then op_ro.operatorname
      end operator,

      CASE
        when je.journaltype = 'ORPA-SAF' then 'Y'
        when tr.CALCULATEDFEE <> 0 and tr.CALCULATEDFEE is not null then 'Y'
        else 'N'
      end SAFFLAG

from EMV.JOURNAL_ENTRY_PARSED_V je left join EMV.JOURNAL_ENTRY_TYPE jt     on je.JournalEntryTypeID = jt.JournalEntryTypeID
                               left join EMV.BANKCARD_PAYMENT bp       on je.BankCardPaymentID  = bp.BankCardPaymentID
                               left join EMV.BANKCARD b                on bp.BankCardID         = b.BankCardID
                               left join EMV.TRIP tr                   on je.TripID             = tr.TripID
                               left join EMV.LOCALE lo                 on tr.ENTRYSTOPID        = lo.LOCALEID
                               left join EMV.LOCALE la                 on tr.EXITSTOPID        = la.LOCALEID
                               left join ta on bp.PGRETRIEVALREFNBR  = ta.RRN
                               left join EMV.transaction_capture_v tc  on bp.PGRETRIEVALREFNBR  = tc.RRN
                               left join EMV.confirmation co           on bp.PGRETRIEVALREFNBR  = co.I037RETRIEVALREFERENCENUM
                               left join EMV.multi_purse mp on je.multipursetypeid = mp.multipursetypeid and je.multipurseusageid = mp.multipurseusageid
                               left join EMV.MERCHANT_DESCRIPTION md1 on md1.caicid = tc.caicid
                               left join emv.merchant_description md2 on md2.caicid = co.merchantid
                               left join emv.ets_rail_apportionment_matrix eam on tr.entrystopid = eam.entrynlc and tr.exitstopid = eam.exitnlc
                               left join emv.ets_operator op_orpa on je.locationnlc = op_orpa.nlc     -- operator for ORPA
                               left join EMV.ets_operator op_nr          on tr.entrystopID = op_nr.nlc     -- operator for Non-Rail
                               left join (select distinct etsoperatorid, operatorname, transportmode from emv.ets_operator) op_ro on op_ro.etsoperatorid = eam.apportionedoperatorid    -- Operator Ref Data for Rail
   where    je.EmvInsertedDtm >= trunc(sysdate - 1 - 213) + 4.5/24 -- Select all records before 4:30AM (4am cut off, but 30mins to cater for transfer time from ABP)
        and je.EmvInsertedDtm < trunc(sysdate - 213)  + 4.5/24
        -- run for 5/03 and 6/03
   order by
      je.EmvInsertedDtm,
      je.JournalEntryID;
      
-- Personal queries...      
select * from emv.ets_rail_apportionment_matrix ;
select * from emv.ets_operator;
select * from emv.journal_entry_type;
select * from emv.journal_entry_parsed_v;

select *
from EMV.JOURNAL_ENTRY
where journalentryid in (362684, 362681, 362655)
;

define TestTime = TO_DATE('30/NOV/2018 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
select je.JOURNALENTRYID, je.TRANSITACCOUNTID, je.TRIPID, bc.PGRETRIEVALREFNBR, je.TRANSACTIONDTM + 11/24, je.TRANSACTIONAMT, je.ALLOCATEDDATE, je.EMVINSERTEDDTM
from EMV.JOURNAL_ENTRY je
join EMV.BANKCARD_PAYMENT bc
on je.BANKCARDPAYMENTID = bc.BANKCARDPAYMENTID
where je.EMVINSERTEDDTM > &TestTime + 4.5/24
and je.EMVINSERTEDDTM < &TestTime + 4.5/24 + 30/(24*60)
and je.TRANSACTIONDTM + 11/24 >= &TestTime - 1 + 4/24
and je.TRANSACTIONDTM + 11/24 < &TestTime + 4/24
order by je.JOURNALENTRYID asc
;

define TestTime = TO_DATE('30/NOV/2018 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
select *
from EMV.TRIP
where EMVINSERTEDDTM > &TestTime + 4.5/24
and EMVINSERTEDDTM < &TestTime + 4.5/24 + 30/(24*60)
and TRANSACTIONDTM + 11/24 >= &TestTime - 1 + 4/24
and TRANSACTIONDTM + 11/24 < &TestTime + 4/24
;
select TRIPID, TRANSITACCOUNTID, FAREDUE, PAIDAMT, ENTRYTRANSACTIONDTM + 11/24, EXITTRANSACTIONDTM + 11/24, EMVINSERTEDDTM
from EMV.TRIP
where TRIPID = 1694820
;