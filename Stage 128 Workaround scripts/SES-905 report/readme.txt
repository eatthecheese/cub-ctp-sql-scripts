SES905 occurrence report
For any issues contact James Lee

1. Summary
	When run, this report outputs all Trips affected by CTP defect SES905 Intra-modal transfer from Airport to non-ALC station trip will apply Longest trip rule- different from OPAL [UAT 20768].

2. Instructions

	Run the 2x pre-run define statements, i.e.
	define l_testDate = TO_DATE('20/JUL/2019 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
	define l_timezoneModifier = 10;

	l_testDate - the summary period for which you would like to detect Trips for, i.e. 0400 testDate -> 0400 testDate + 1 day.
	l_timezoneModifier - the current timezone offset from UTC. E.g. 10 for AEST, 11 for AEST + DST.
	
	Then run the main report script. Check the refund_amt column for how much should be refunded as per the expected fare logic.
	
3. Changelog

	- v1.2 released 1st Aug 2019
		Now excludes Trips with refund_amt = 0 
		Now reports only from l_testDate + 6 days, i.e. 1 week

	- v1.0 released 26th Jul 2019
		Initial version