-- Functions for Purse Fare Logic


--Rail/Ferry Tap On and RTD_HEADER
SELECT a.daykey,a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode,
a.locationname, a.transportmode,  a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.dailycapped, b.firstentrytime, b.safadjustment, b.safdetails, b.unstartedexit,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
--from tds_rtd_header a, tds_rtd_tag_ON_sv b
from tdm_rtd_header a, tdm_rtd_tag_ON_sv b
where a.smartcardid in (70013455)
--and a.daykey in (13433)
and a.transactiontype = 40
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap on for Rail/Ferry Purse Fare Logic

--Rail/Ferry Tap Off and RTD_HEADER
SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, 
a.locationname, a.transportmode, b.unstartedexit, a.svadded, a.svbalance, b.fullexitadjustment, b.exitadjustment, b.dailycapped, b.intermodaltransfertypecode, b.firstentrytime, b.firstentrynlc, b.saf, b.safdetails, b.safadjustment,
b.transferflagexit, b. daykey, b.batchid, b.filerecordno, b.position,  b.smartcardid, b.foucount, b.distancebandcode, b.*
--from tds_rtd_header a, tds_rtd_tag_OFF_sv b
from tdm_rtd_header a, tdm_rtd_tag_OFF_sv b
where a.smartcardid in (70200388)
--and a.daykey in (12345)
and a.transactiontype = 41
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap off for Rail/Ferry Purse Fare Logic

--Tap On Only and RTD_HEADER
SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode,
a.locationname, a.transportmode, b.unstartedexit, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.dailycapped,b.firstentrynlc,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_on_only_sv b
--from tdm_rtd_header a, tdm_rtd_tag_on_only_sv b
where a.smartcardid in (70013405)
--and a.daykey in ()
and a.transactiontype = 44
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard desc; -- Tap on only for Purse Fare Logic

--Tap On Reversal and RTD_HEADER
SELECT a.daykey, a.batchid, a.filerecordno, a.position, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, 
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_ON_sv_rev b
where a.smartcardid in (12345678) and a.daykey in (12345)
and a.transactiontype = 43
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard desc; -- Tap on reversal for Rail/Ferry Purse Fare Logic

--Bus Tap On and RTD_HEADER
SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, a.routevariant,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.transferflagentry, b.firstentrytime,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_ON_bus_sv b
where a.smartcardid in (70201349) and a.daykey in (13293)
and a.transactiontype = 45
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap on for Bus Purse Fare Logic

--Bus Tap Off and RTD_HEADER
SELECT a.daykey, a.smartcardid, a.sequencenocard, a.transactiontype, b.validationresultcode, b.validationtypecode, a.routevariant,
a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullexitadjustment, b.exitadjustment, b.intermodaltransfertypecode, b.transferflagexit, b.firstentrytime, b.foucount,b.distancebandcode,
b. daykey, b.batchid, b.filerecordno, b.position, b.smartcardid, b.*
from tds_rtd_header a, tds_rtd_tag_OFF_bus_sv b
where a.smartcardid in (12345678) and a.daykey in (12345)
and a.transactiontype = 46
and (a.daykey=b.daykey)
and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequencenocard asc; -- Tap off for Bus Purse Fare Logic

--DD_CARD_TRANSACTION
SELECT *
from dd_card_transaction
where smartcardid in 700122594
--and daykey in 13436
order by sequenceno; -- Card Transaction validation

--DD_JOURNEY_SEGMENT
SELECT daykey, smartcardid, startsequenceno, endsequenceno, transportmode, journeytype, originlocationname, destinationlocationname, originlocationkey, destinationlocationkey, discountedadjustment, saf, starttransactiontype, endtransactiontype
from dd_journey_segment
where smartcardid in 70013457
and daykey >= 13744; -- DD_JOURNEY_SEGMENT validation

SELECT *
from dd_card_transaction
where smartcardid in 700122843
--and daykey = 13742
--and locationname = 'Domestic'
order by sequenceno desc;
--and daykey in 13434; -- DD_JOURNEY_SEGMENT validation

SELECT *
from dd_card_transaction
where smartcardid in (70013583, 70013582, 3424121, 70201178, 70013576, 70020183,70204254, 70013579,70013587,70013577)
and daykey in 13436
order by sequenceno; -- Card Transaction validation

-- 1: Ferry to Rail-- Inter Modal Transfer Types

-- 2: Bus to Rail
-- 3: Rail to Ferry
-- 4: Bus to Ferry
-- 5: Rail to Bus
-- 6: Ferry to Bus
