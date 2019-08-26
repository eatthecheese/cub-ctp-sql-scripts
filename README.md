CTP SQL Scripts 
A repo of useful SQL scripts for CTP

1. Introduction

TO COME

2. Script Information

	2.1 Analysis scripts
	
		### apportion_incorrect_fares.sql
		This script is used to retrieve SAF + Operator info for apportionment, given some TRIPIDs.
		This is due to the open CTP Bus defect where Trips are getting priced incorrectly.
		This script is run on the given TRIPID's, and outputs the Operator for which the refund amount will be taken.
		
		### Bus Reports.sql
		This script was used to find statistics relating to Implied Transfers on Opal Bus for studying the impact on CTP.
		
		### Finance Incident queries.sql
		There are numerous queries here on ABP tables to find Trip, Tap, or Journal Entry information for analysing Incidents.
		These are useful when the ABP GUI is slow or doesn't provide the info to the detail required for analysis.

		### Find CTP Journal Entries.sql
		Somewhat of a companion script to the Incident queries. Finds journal entries for analysis in Production incidents.
		
		### Missing GRRCN lookup.sql
		This script can find the status of AMEX reconciliation on CPA by querying the GRRCN contents.
		This is useful for analysis AMEX related incidents from Finance, specifically to do with potential missing settlements.

	2.2 Card Cleanup scripts
	
		### Delete ABP Account.sql
		Script used to delete all traces of a given TRANSIT_ACCOUNT_ID in ABP and its child references.
		This should be ported to EMV eventually so that both EMV and ABP have the same info regarding deleted accounts.

	2.3 Stage 128 Workaround scripts
	
		### A_Arrears (W5).sql
		DEPRECATED, retained for posterity
		
		### A_SQL (W1-4) - DST OFF.sql
		Workarounds 1 - 4 for use during non-DST periods. This is because ABP internally uses UTC time and needs to be converted to local time.
		
		### A_SQL (W1-4).sql
		Workarounds 1 - 4 for use during DST-on periods.
		
		### EMV - A_SQL (W1-4) - DST OFF.sql
		Workarounds 1 - 4 utilising the power of the EMV operator apportionment views.
		This shall replace the previous workaround script.
		
		### EMV - A_SQL (W1-4).sql
		The DST-on equivalent of EMV - A_SQL (W1-4) - DST OFF.sql.
		
		2.3.1 SES-905 report
		
		2.3.2 SES-948 report
	
	
	2.4 Stage_131_scripts
	
		### CSELR-locale-insert.sql
		
		### Insert scripts for Locale table.sql
		
		### Update script to align with BDP.sql

3. Changelog

	0.1 - 2019 Aug 26
		- Created this readme for this repo to track changes to CTP SQL scripts.
		- Added EMV versions of the workaround 1-4 scripts to make them compliant with bus apportionment
		A_SQL (W1-4).sql & A_SQL (W1-4) - DST OFF.sql
			- Brought in the latest changes to these scripts to sync with what's in Sharepoint Server
		EMV - A_SQL (W1-4) - DST OFF.sql & EMV - A_SQL (W1-4).sql
			- Created these scripts
			- Functionally identical to existing scripts, except it uses the VOIDFLAG column because VOID_TYPE is not in EMV.Trip
		

4. Known Issues

	- No trace of Workaround 6 because that is deprecated
	- Need better description of SES-905 and SES-948 reports
	- Need better instructions for Workaround 1-4 reports
	
5. Acknowledgements