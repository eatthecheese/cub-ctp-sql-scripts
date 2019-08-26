SELECT a.daykey,a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode,
a.locationname, a.transportmode,  a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.dailycapped, b.firstentrytime, b.safadjustment, b.safdetails, b.unstartedexit,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_ON_sv b
--from tdm_rtd_header a, tdm_rtd_tag_ON_sv b
where a.daykey in (13386) and
a.locationname in ('Town Hall')
--a.smartcardid in 70013370
and a.transactiontype = 40
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap on for Rail/Ferry Purse Fare Logic

SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, 
a.locationname, a.transportmode, b.unstartedexit, a.svadded, a.svbalance, b.fullexitadjustment, b.exitadjustment, b.dailycapped, b.intermodaltransfertypecode, b.firstentrytime, b.firstentrynlc, b.saf, b.safdetails, b.safadjustment,
b.transferflagexit, b. daykey, b.batchid, b.filerecordno, b.position,  b.smartcardid, b.foucount, b.distancebandcode, b.*
--from tds_rtd_header a, tds_rtd_tag_OFF_sv b
from tdm_rtd_header a, tdm_rtd_tag_OFF_sv b
where a.smartcardid in (3423086) 
and a.daykey in (13289)
--and a.locationname in ('Jubilee Park LR')
--and a.transportmode in ('RAIL')
and a.transactiontype = 41
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap off for Rail/Ferry Purse Fare Logic