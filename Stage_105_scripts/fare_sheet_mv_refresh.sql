/* Part 1: Run refresh on both MVs */

BEGIN DBMS_SNAPSHOT.REFRESH( '"ABP_MAIN"."FARE_RULE_IN_USE"'); end;
BEGIN DBMS_SNAPSHOT.REFRESH( '"ABP_MAIN"."FARE_RULE_X_CONC_LEVEL_IN_USE"'); end;

/* Part 2: Update the Max Fare Rule Effective Datetime in SYS_INFO */
/* Update the time below such that the effective datetime matches that of the CSELR go-live for CTP*/
update ABP_MAIN.SYS_INFO
set MAX_FARE_RULE_EFFECTIVE_DTM  = TO_TIMESTAMP('2019-12-05 04:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF6') -10/24
;