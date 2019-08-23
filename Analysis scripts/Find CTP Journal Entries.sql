----------------------------------------------------------------------
-- SEARCH A JOURNAL ENTRY BY RRN on ABP
----------------------------------------------------------------------
select je.*, bp.*
from ABP_MAIN.JOURNAL_ENTRY je
join ABP_MAIN.BANKCARD_PAYMENT bp
on je.BANKCARD_PAYMENT_ID = bp.BANKCARD_PAYMENT_ID
where bp.PG_RETRIEVAL_REF_NBR = '000045210645'
;
--====================================================================

----------------------------------------------------------------------
-- QUERY TO FIND TRIP DATA FOR A GIVEN DAY on EMV
----------------------------------------------------------------------
define TestDate = TO_DATE('06/JUN/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
define EndDate = TO_DATE('07/JUN/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
define timezone_mod = 10;
select 
--*
TRIPID, TRANSITACCOUNTID, TOKENID, TAPCOUNT, ENTRYTRANSACTIONDTM + &timezone_mod/24 "Entry time", EXITTRANSACTIONDTM + &timezone_mod/24 "Exit time", ENTRYSTOPID, EXITSTOPID, JOURNEYID, 
CALCULATEDFARE, FAREDUE, PAIDAMT, BANKCARDAMT, CAPAMT, INSERTEDDTM, UPDATEDDTM, EMVINSERTEDDTM
from EMV.TRIP
where 
ENTRYTRANSACTIONDTM + &timezone_mod/24 >= &TestDate + 4/24
and ENTRYTRANSACTIONDTM +&timezone_mod/24 <= &EndDate + 4/24
and TRANSITACCOUNTID = 100010891099
;
--====================================================================

----------------------------------------------------------------------
-- QUERY TO FIND JOURNAL ENTRIES FOR A GIVEN DAY & ACCOUNT on EMV
----------------------------------------------------------------------
define TestDate = TO_DATE('31/MAY/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
define timezone_mod = 10;
select 
--je.*, bp.*
    je.JOURNALENTRYID, je.TRANSITACCOUNTID, je.JOURNALENTRYTYPEID, je.BANKCARDPAYMENTID, je.TRIPID, je.TRANSACTIONDTM + &timezone_mod/24, je.TRANSACTIONAMT, je.ACTIONTYPEID,
    je.REVERSALFLAG, je.PRICECOUNT, je.INSERTEDDTM + &timezone_mod/24, je.ALLOCATEDDATE, bp.BANKCARDID, bp.PGRETRIEVALREFNBR, bp.PGSETTLEMENTAMT, 
    cf.I004AMOUNTTRANSACTION "CPA amount", bp.PGSETTLEMENTDTM + &timezone_mod/24,
    bp.PGCAPTUREDATE, bp.REQUESTEDAMT, bp.AUTHORIZEDAMT, bp.CARDPRESENTFLAG, bp.INSERTEDDTM + &timezone_mod/24, bp.UPDATEDDTM + &timezone_mod/24, 
    cf.MSGSETTLEMENTSTATUS, cf.PANPARTIAL, cf.CREDITCARDTYPEID, cf.*
from EMV.JOURNAL_ENTRY je
join EMV.BANKCARD_PAYMENT bp
on je.BANKCARDPAYMENTID = bp.BANKCARDPAYMENTID
join EMV.CONFIRMATION cf
on cf.I037RETRIEVALREFERENCENUM = bp.PGRETRIEVALREFNBR
where
    je.TRANSACTIONDTM + &timezone_mod/24 >= &TestDate + 4/24
    and je.TRANSACTIONDTM + &timezone_mod/24 <= &TestDate + 1 + 4/24
    and je.TRANSITACCOUNTID = 100001023850
order by je.JOURNALENTRYID desc
;
--====================================================================

----------------------------------------------------------------------
-- QUERY TO FIND TAPS FOR A GIVEN DAY & ACCOUNT on EMV
----------------------------------------------------------------------
select 
    --*
    tp.TAPID, tp.TRANSACTIONID, tp.TRANSACTIONDTM + &timezone_mod/24 "Tap time", tp.TOKENID, tp.STOPID, tp.TAPTYPEID, tp.TAPSTATUSID, tp.TRIPID, tp.TRANSITACCOUNTID,
    tp.TAPSTATUSDESCRIPTION
from EMV.TAP tp
where 
    tp.TRANSACTIONDTM + &timezone_mod/24 >= &TestDate + 4/24
    and tp.TRANSACTIONDTM + &timezone_mod/24 <= &TestDate + 1 + 4/24
    and tp.TRANSITACCOUNTID = 100001023850
order by tp.TRANSACTIONDTM desc
;
--====================================================================