-- PURSE QUERIES
SELECT a.daykey,a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, a.transactiondate, a.transactiontime, a.transportmode,
a.locationname, a.transportmode,  a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.dailycapped, b.firstentrytime, b.safadjustment, b.safdetails, b.unstartedexit,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_ON_sv b
--from tdm_rtd_header a, tdm_rtd_tag_on_sv b
where a.daykey = (14173) and
a.smartcardid in 70204571
--b.validationresultcode = 55
--and a.daykey = (13982)
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
--order by b.firstentrytime desc;
order by a.daykey desc;
--order by a.smartcardid desc, a.sequencenocard asc; -- Tap on for Rail/Ferry Purse Fare Logic

select * from tds_rtd_header where hostnlc = 402 and hostplinthnumber = 22;

select * from tdm_rtd_header where smartcardid in 70013461
and daykey = (13860) ;

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, 
a.locationname, a.transportmode, b.unstartedexit, a.svadded, a.svbalance, b.fullexitadjustment, b.exitadjustment, b.dailycapped, b.intermodaltransfertypecode, b.firstentrytime, b.firstentrynlc, b.saf, b.safdetails, b.safadjustment,
b.transferflagexit, b. daykey, b.batchid, b.filerecordno, b.position,  b.smartcardid, b.foucount, b.distancebandcode, b.*
from tdm_rtd_header a, tdm_rtd_tag_off_sv b
--from tds_rtd_header a, tds_rtd_tag_OFF_sv b
where 
a.smartcardid in (700769484) 
--b.validationresultcode = 55
and a.daykey = (14156)
--and b.validationtypecode = 13 and transportmode = 'RAIL'
--and a.locationname in ('Jubilee Park LR')
--and a.transportmode in ('RAIL')
and a.transactiontype in (41, 42, 43)
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.daykey desc;
--order by a.smartcardid desc, a.sequencenocard asc; -- Tap off for Rail/Ferry Purse Fare Logic

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode,
a.locationname, a.transportmode, b.unstartedexit, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.dailycapped,b.firstentrynlc,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tdm_rtd_header a, tdm_rtd_tag_on_only_sv b
--from tdm_rtd_header a, tdm_rtd_tag_on_only_sv b
where a.smartcardid in (70013540)
--and a.daykey in (13294)
and a.transactiontype = 44
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard desc; -- Tap on only for Purse Fare Logic

SELECT a.daykey, a.batchid, a.filerecordno, a.position, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, 
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tdm_rtd_header a, tdm_rtd_tag_ON_sv_rev b
where a.smartcardid in (3001280) and a.daykey in (13742)
and a.transactiontype = 43
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard desc; -- Tap on reversal for Rail/Ferry Purse Fare Logic

SELECT a.daykey,a.busdriverconsoleid, a.busid, a.depotid, a.driverid, a.shiftid, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, a.routevariant,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.transferflagentry, b.firstentrytime,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*, a.*
--from tds_rtd_header a, tds_rtd_tag_ON_bus_sv b
from CDSPROD1.tdm_rtd_header a, CDSPROD1.tdm_rtd_tag_ON_bus_sv b
where a.smartcardid in (22313661) and a.daykey = 14334
--and a.sequencenocard in (37)
and a.transactiontype = 45
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap on for Bus Purse Fare Logic

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, a.routevariant,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullexitadjustment, b.exitadjustment, b.intermodaltransfertypecode, b.transferflagexit, b.firstentrytime, b.foucount,b.distancebandcode,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*, a.*
from CDSPROD1.tdm_rtd_header a, CDSPROD1.tdm_rtd_tag_OFF_bus_sv b
--from tdm_rtd_header a, tdm_rtd_tag_OFF_bus_sv b
where a.smartcardid in (29721518) and a.daykey = 14334
and a.transactiontype = 46
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap off for Bus Purse Fare Logic

select *
from CDSPROD1.DD_CARD_TRANSACTION
where smartcardid = 24143131
and daykey = 14334
order by transactiontime asc;

select *
from CDSPROD1.TDM_RTD_HEADER
where smartcardid = 24143131
and daykey = 14334
order by transactiontime asc;

select *
from CDSPROD1.DD_JOURNEY_SEGMENT
where smartcardid = 29721518
and daykey = 14334
order by entrytime asc;