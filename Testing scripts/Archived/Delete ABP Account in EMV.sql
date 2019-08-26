-- Run this after you have deleted the account from ABP to complete the card cleaning process.
-- This will remove all traces of a token and its account from EMV schema as well.

-- Run below section before executing PL/SQL Block
set serveroutput on;
CREATE OR REPLACE TYPE arr_type IS TABLE OF NUMBER;
alter session set current_schema = EMV;

-- Do not execute previous section if PL/SQL Block fails and you have not switched sessions.
DECLARE
  a number := &ta;
  t arr_type :=arr_type();
  b arr_type :=arr_type();
  p arr_type :=arr_type();
BEGIN
  select token_id BULK COLLECT into t from abp_main.token_info where transit_account_id = a;
  select bankcard_id BULK COLLECT into b from abp_main.token_info where transit_account_id = a;
  select purse_id BULK COLLECT into p from abp_main.TRANSIT_ACCOUNT_X_PURSE where transit_account_id = a;
    for i in 1..t.count loop
        dbms_output.put_line(t(i));
  end loop;
  for i in 1..b.count loop
        dbms_output.put_line(b(i));
  end loop;
  --delete from RIDER_CLASS_HISTORY where transit_account_id = a;
  --delete from ACCOUNT_STATUS_HISTORY where transit_account_id = a or TOKEN_ID in (select * from table(t));
  --delete from API_LOG where account_id = a;
  --delete from TOKEN_STATUS_HISTORY where TOKEN_ID in (select * from table(t));
  delete from TRANSIT_ACCOUNT_X_TOKEN where transitaccountid = a or TOKENID in (select * from table(t));
  --delete from ENABLEMENT_FEE_STATUS_HISTORY where token_id in (select * from table(t));
  delete from RISK_LIST where tokenid in (select * from table(t));
  delete from TAP where TOKENID in (select * from table(t)) or transitaccountid = a;
  delete from TRIP_PRICE_HISTORY where tripid in (select tripid from TRIP where transitaccountid = a or tokenid in (select * from table(t)));
  delete from JOURNAL_ENTRY where transitaccountid = a;
  --delete from NOTE where transit_account_id = a or token_id in (select * from table(t));
  delete from TRIP where transitaccountid = a or tokenid in (select * from table(t));
  delete from JOURNEY where transitaccountid = a or tokenid in (select * from table(t));
  delete from NEGATIVE_LIST where transitaccountid = a or tokenid in (select * from table(t));
  delete from PURSE_LOAD where purseid in (select * from table(p));
  delete from PURSE_LOAD where bankcardpaymentid in (select bankcardpaymentid from bankcard_payment where transitaccountid = a);
  delete from TRANSIT_ACCOUNT_X_PURSE where transitaccountid = a or purseid in (select * from table(p));
  delete from PURSE where purseid in (select * from table(p));
  --delete from ALERT_QUEUE where transit_account_id = a;
  delete from BANKCARD_PAYMENT where transitaccountid = a;
  --delete from CAPPING where transit_account_id = a or TOKEN_ID in (select * from table(t));
  --delete from TICKLER where transit_account_id = a;
  --delete from POSITIVE_LIST where transit_account_id = a or TOKEN_ID in (select * from table(t));
  --delete from ACCOUNT_LOAD where transit_account_id = a;
  --delete from AUTOLOAD_EVENT where autoload_id in (select autoload_id from AUTOLOAD where transit_account_id = a);
  --delete from AUTOLOAD where transit_account_id = a;
  EXECUTE IMMEDIATE 'alter table TOKEN disable constraint FK5_TOKEN'; -- Do FKs matter in EMV?
  EXECUTE IMMEDIATE 'alter table BANKCARD disable constraint FK1_BANKCARD'; -- Do FKs matter in EMV?
  delete from TOKEN where transitaccountid = a or TOKENID in (select * from table(t));
  delete from TRANSIT_ACCOUNT where transitaccountid = a;
  delete from BANKCARD where tokenid in (select * from table(t)) or bankcardid in (select * from table(b));
  delete from TRANSIT_ACCOUNT_X_TOKEN where transit_account_id = a or token_id in (select * from table(t)); -- isn't this a duplicate of line 29??
  EXECUTE IMMEDIATE 'alter table BANKCARD enable constraint FK1_BANKCARD'; -- Do FKs matter in EMV?
  EXECUTE IMMEDIATE 'alter table TOKEN enable constraint FK5_TOKEN'; -- Do FKs matter in EMV?
  commit;
END;