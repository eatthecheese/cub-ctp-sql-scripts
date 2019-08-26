-- PRODUCT QUERIES
SELECT a.daykey, a.sequenceno, a.smartcardid, a.transactiontype, a.locationname, a.transportmode,
b.validationresultcode, b.validationtypecode, b.firstentrynlc, a.hostnlc, a.transactiontime, b.ticketparameters, b.ridesremaining, b.passengertypecode, b.discountentitlementcode,
b.tickettypecode, b.ticketfeatures, b.geographicvaliditycode, b.geographicvaliditydesc, a.*, b.*
--from tdm_rtd_header a, tdm_rtd_tag_ON_tkt b
from tds_rtd_header a, tds_rtd_tag_ON_tkt b
where a.smartcardid in (700129143)
--where a.daykey >= 13000
and a.transactiontype=50
--and b.validationresultcode = 53
and (a.daykey=b.daykey)
and (b.batchid= a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequenceno asc; -- Tap on for Rail/Ferry Product Fare Logic

SELECT a.daykey, a.batchid, a.filerecordno, a.position, a.sequenceno, a.smartcardid, a.transactiontype, a.locationname, a.transportmode, b.validationresultcode, b.validationtypecode, a.rtdid, a.transactiontime,
b.firstentrynlc, a.hostnlc, b.firstentrytime, b.ticketparameters, b.ridesremaining, b.distancebandstravelled, a.busroutevarianttypedesc, a.routevariant, a.hostplinthnumber, a.cardtypekey, a.*, b.*
from tds_rtd_header a, tds_rtd_tag_OFF_tkt b
--from tdm_rtd_header a, tdm_rtd_tag_OFF_tkt b
where a.smartcardid in (700767325)
--and a.daykey in 13541
and a.transactiontype=51
and (a.daykey=b.daykey)
and (b.batchid= a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequenceno asc; -- Tap off for Rail/Ferry Product Fare Logic

SELECT a.daykey, a.sequenceno, a.smartcardid, a.transactiontype, a.locationname, a.transportmode,
b.validationresultcode, b.validationtypecode, a.transactiontime, b.ticketparameters, b.ridesremaining, b.passengertypecode, b.discountentitlementcode,
b.tickettypecode, b.ticketfeatures, b.geographicvaliditycode, b.geographicvaliditydesc, a.*, b.*
from tds_rtd_header a, tds_rtd_tag_ON_bus_tkt b
--from tdm_rtd_header a, tdm_rtd_tag_ON_bus_tkt b
where a.smartcardid in 700766177
--and a.daykey in 13488
--and a.transactiontype=54
and (a.daykey=b.daykey)
and (b.batchid= a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequenceno asc; -- Tap on for Bus Product Fare Logic

SELECT a.daykey, a.batchid, a.filerecordno, a.position, a.sequenceno, a.smartcardid, a.transactiontype, a.locationname, a.transportmode, b.validationresultcode, b.validationtypecode, a.rtdid, a.transactiontime, b.firstentrytime, b.ticketparameters, b.ridesremaining, b.distancebandstravelled, a.busroutevarianttypedesc, a.routevariant, a.hostplinthnumber, a.cardtypekey, a.*, b.*
from tds_rtd_header a, tds_rtd_tag_OFF_tkt b
--from tdm_rtd_header a, tdm_rtd_tag_OFF_bus_tkt b
where a.smartcardid in 700766177
--and a.daykey in 13488
and a.transactiontype=55
and (a.daykey=b.daykey)
and (b.batchid= a.batchid and b.filerecordno=a.filerecordno
and b.position=a.position and b.smartcardid=a.smartcardid)
order by a.smartcardid desc, a.sequenceno asc; -- Tap off for Bus Product Fare Logic