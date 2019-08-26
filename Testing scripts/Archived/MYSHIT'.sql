SELECT a.daykey,a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode,
a.locationname, a.transportmode,  a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.dailycapped, b.firstentrytime, b.safadjustment, b.safdetails, b.unstartedexit,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
--from tds_rtd_header a, tds_rtd_tag_ON_sv b
from tdm_rtd_header a, tdm_rtd_tag_ON_sv b
where --a.daykey in (13604) and
a.smartcardid in 70013457
--a.locationname in 'Circular Quay, No. 2 Wharf'
and a.daykey >= (13742)
--and a.smartcardid in (3423177)
--and a.sequencenocard in (32)
--and a.locationname in ('Dulwich Hill LR')
--and a.transportmode in ('RAIL')
--and a.transactiontype = 40
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
--order by b.firstentrytime desc;
order by a.smartcardid desc, a.sequencenocard asc; -- Tap on for Rail/Ferry Purse Fare Logic

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, 
a.locationname, a.transportmode, b.unstartedexit, a.svadded, a.svbalance, b.fullexitadjustment, b.exitadjustment, b.dailycapped, b.intermodaltransfertypecode, b.firstentrytime, b.firstentrynlc, b.saf, b.safdetails, b.safadjustment,
b.transferflagexit, b. daykey, b.batchid, b.filerecordno, b.position,  b.smartcardid, b.foucount, b.distancebandcode, b.*
from tdm_rtd_header a, tdm_rtd_tag_OFF_sv b
--from tds_rtd_header a, tds_rtd_tag_OFF_sv b
where a.smartcardid in (70013457) 
and a.daykey >= (13742)
--and a.locationname in ('Jubilee Park LR')
--and a.transportmode in ('RAIL')
and a.transactiontype in (41, 42, 43)
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap off for Rail/Ferry Purse Fare Logic

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode,
a.locationname, a.transportmode, b.unstartedexit, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.dailycapped,b.firstentrynlc,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tdm_rtd_header a, tdm_rtd_tag_on_only_sv b
--from tdm_rtd_header a, tdm_rtd_tag_on_only_sv b
where a.smartcardid in (70200411)
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

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, a.routevariant,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.transferflagentry, b.firstentrytime,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_ON_bus_sv b
--from tdm_rtd_header a, tdm_rtd_tag_ON_bus_sv b
where a.smartcardid in (70013464) and a.daykey >=13700 
--and a.sequencenocard in (37)
and a.transactiontype = 45
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap on for Bus Purse Fare Logic

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, a.routevariant,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullexitadjustment, b.exitadjustment, b.intermodaltransfertypecode, b.transferflagexit, b.firstentrytime, b.foucount,b.distancebandcode,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_OFF_bus_sv b
--from tdm_rtd_header a, tdm_rtd_tag_OFF_bus_sv b
where a.smartcardid in (70013464) and a.daykey >= 13700
and a.transactiontype = 46
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap off for Bus Purse Fare Logic

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.firstentrytime,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_ON_bus_sv_REV b
where a.smartcardid in (3425082) and a.daykey in (13289)
and a.transactiontype = 47
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap on for Bus Purse Fare Logic

select daykey,smartcardid,journeyindex,journeyid,starttime,endtime,startsequenceno,endsequenceno,
transportmode,journeytype,originlocationname,destinationlocationname,ridesremaining
from dd_journey 
where smartcardid in (70201291) and daykey = SELECT a.daykey, a.batchid, a.filerecordno, a.position, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, 
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_ON_sv_rev b
where a.smartcardid in (70201182) and a.daykey in (13201)
and a.transactiontype = 43
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard desc; -- Tap on reversal for Rail/Ferry Purse Fare Logic

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, a.routevariant,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.transferflagentry, b.firstentrytime,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_ON_bus_sv b
where a.smartcardid in (3423613) and a.daykey in (13260)
and a.transactiontype = 45
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap on for Bus Purse Fare Logic

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, a.routevariant,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullexitadjustment, b.exitadjustment, b.intermodaltransfertypecode, b.transferflagexit, b.firstentrytime, b.foucount,b.distancebandcode,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_OFF_bus_sv b
where a.smartcardid in (3423613) and a.daykey in (13260)
and a.transactiontype = 46
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap off for Bus Purse Fare Logic

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.firstentrytime,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_ON_bus_sv_REV b
where a.smartcardid in (3425082) and a.daykey in (13289)
and a.transactiontype = 47
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap on for Bus Purse Fare Logic

select * from tdm_rtd_header where smartcardid=3003984 and daykey=12275 order by sequenceno desc;

select * from cms_card
where smartcardid = 70013465
and rownum <=100;

