-- Before executing this script make sure you made notes of transit_accout_id, token_id, bankcard_id, master_pg_card_id, 
-- master_pg_card_token, pg_card_id, pg_card_token accociated with account you trying to remove.
-- as an additional action you willhave to login to the CPA console and remove related bankcards from CPA

-- Run below section before executing PL/SQL Block
set serveroutput on;
CREATE OR REPLACE TYPE arr_type IS TABLE OF NUMBER;
alter session set current_schema = ABP_MAIN;

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
  delete from RIDER_CLASS_HISTORY where transit_account_id = a;
  delete from ACCOUNT_STATUS_HISTORY where transit_account_id = a or TOKEN_ID in (select * from table(t));
  delete from API_LOG where account_id = a;
  delete from TOKEN_STATUS_HISTORY where TOKEN_ID in (select * from table(t));
  delete from TRANSIT_ACCOUNT_X_TOKEN where transit_account_id = a or TOKEN_ID in (select * from table(t));
  delete from ENABLEMENT_FEE_STATUS_HISTORY where token_id in (select * from table(t));
  delete from RISK_LIST where token_id in (select * from table(t));
  delete from TAP where TOKEN_ID in (select * from table(t)) or transit_account_id = a;
  delete from TRIP_PRICE_HISTORY where trip_id in (select trip_id from TRIP where transit_account_id = a or token_id in (select * from table(t)));
  delete from JOURNAL_ENTRY where transit_account_id = a;
  delete from NOTE where transit_account_id = a or token_id in (select * from table(t));
  delete from TRIP where transit_account_id = a or token_id in (select * from table(t));
  delete from JOURNEY where transit_account_id = a or token_id in (select * from table(t));
  delete from NEGATIVE_LIST where transit_account_id = a or token_id in (select * from table(t));
  delete from PURSE_LOAD where purse_id in (select * from table(p));
  delete from PURSE_LOAD where bankcard_payment_id in (select bankcard_payment_id from bankcard_payment where transit_account_id = a);
  delete from TRANSIT_ACCOUNT_X_PURSE where transit_account_id = a or purse_id in (select * from table(p));
  delete from PURSE where purse_id in (select * from table(p));
  delete from ALERT_QUEUE where transit_account_id = a;
  delete from BANKCARD_PAYMENT where transit_account_id = a;
  delete from CAPPING where transit_account_id = a or TOKEN_ID in (select * from table(t));
  delete from TICKLER where transit_account_id = a;
  delete from POSITIVE_LIST where transit_account_id = a or TOKEN_ID in (select * from table(t));
  delete from ACCOUNT_LOAD where transit_account_id = a;
  delete from AUTOLOAD_EVENT where autoload_id in (select autoload_id from AUTOLOAD where transit_account_id = a);
  delete from AUTOLOAD where transit_account_id = a;
  EXECUTE IMMEDIATE 'alter table TOKEN disable constraint FK5_TOKEN';
  EXECUTE IMMEDIATE 'alter table BANKCARD disable constraint FK1_BANKCARD';
  delete from TOKEN where transit_account_id = a or TOKEN_ID in (select * from table(t));
  delete from TRANSIT_ACCOUNT where transit_account_id = a;
  delete from BANKCARD where token_id in (select * from table(t)) or bankcard_id in (select * from table(b));
  delete from TRANSIT_ACCOUNT_X_TOKEN where transit_account_id = a or token_id in (select * from table(t));
  EXECUTE IMMEDIATE 'alter table BANKCARD enable constraint FK1_BANKCARD';
  EXECUTE IMMEDIATE 'alter table TOKEN enable constraint FK5_TOKEN';
  commit;
END;