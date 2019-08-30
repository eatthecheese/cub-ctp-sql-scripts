/* Makes the following changes:
ABP > Fares > Operator > Sydney Light Rail (i.e. Operator ID = 10)
Balance Threshold amount will increase from $3.73 to $4.80. This means the ABP will request a new hold if the auth amount on the token falls below $4.80. This is to accommodate the new Fare Band 3 for Light Rail.
Default peak fare & Default off-peak fare will increase from $3.73 to $4.80. This means when there is a tap timeout for a Sydney Light Rail tap, the fare charged is now $4.80. This is because $4.80 is the new highest possible fare, i.e. FB3.
*/

update abp_main.operator
set HOLD_THRESHOLD_AMT = 480, DEFAULT_PEAK_FARE = 480, DEFAULT_OFFPEAK_FARE = 480
where OPERATOR_ID = 10
;