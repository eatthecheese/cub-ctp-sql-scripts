SES948 occurrence report
For any issues contact James Lee

1. Summary
	When run, this report outputs all Trips affected by CTP defect SES948 Incorrect Overall Fare for Ferry trip then intra-modal CQ3-Manly trip.

2. Instructions

	Run the 3x pre-run define statements, i.e.
	define l_testDate = TO_DATE('20/JUL/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
	define l_timezoneModifier = 10;
	define l_ferryAdultFB2Fare = 765;

	l_testDate - the summary period for which you would like to detect Trips for, i.e. 0400 testDate -> 0400 testDate + 1 day.
	l_timezoneModifier - the current timezone offset from UTC. E.g. 10 for AEST, 11 for AEST + DST.
	l_ferryAdultFB2Fare - the current FB2 fare amount for an Adult ferry trip.
	
	Then run the main report script. Check the FARE_ACTUAL for the CTP fare, the FARE_EXPECTED for the fare as expected from Opal for the same Trip, 
	and UNDERCHARGE_AMT for a summary amount of how much the customer was undercharged due to the defect.
	
3. Changelog

	- v1.1 released 30th Jul 2019
		Fixed some bugs picking up false positives, found in EIT
		
	- v1.0 released 26th Jul 2019
		Initial version