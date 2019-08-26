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
   where    je.EmvInsertedDtm >= trunc(sysdate - 1) + 4.5/24 -- Select all records before 4:30AM (4am cut off, but 30mins to cater for transfer time from ABP)
        and je.EmvInsertedDtm < trunc(sysdate)  + 4.5/24
   order by
      je.EmvInsertedDtm,
      je.JournalEntryID
    ;
    
    
desc emv.fare_rule;