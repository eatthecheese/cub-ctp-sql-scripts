/* Part 1: Run refresh on both MVs */

BEGIN DBMS_SNAPSHOT.REFRESH( '"ABP_MAIN"."FARE_RULE_IN_USE"'); end;
BEGIN DBMS_SNAPSHOT.REFRESH( '"ABP_MAIN"."FARE_RULE_X_CONC_LEVEL_IN_USE"'); end;

/* Part 2: Update the Max Fare Rule Effective Datetime in SYS_INFO */
/* CSELR fare sheet will be made effective on 9AM 2019 OCT 10*/
update ABP_MAIN.SYS_INFO
set MAX_FARE_RULE_EFFECTIVE_DTM  = TO_TIMESTAMP('2019-10-10 09:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') -10/24
;