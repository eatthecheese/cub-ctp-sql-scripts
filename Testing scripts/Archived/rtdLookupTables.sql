-- REFERENCE TABLES

--SELECT * from rtd_transportmode;

select * from rdd_rtdtransactiontype; -- transaction type

select * from cdsprod1.rdd_cardtype where cardtypekey = 311;

select * from cms_card where smartcardid in (70014185);

select * from rdd_foudiscount
where foubandcode = 2 and transportmode = sysdate between effectivedate and ceaseddate; -- FOUDISCOUNTKEY

select * from rdd_validationresult; -- VALIDATIONRESULTCODE

select * from rdd_devicetype;

select * from rdd_faredistance;

select * from rdd_tickettype where tickettypecode = 7 and ceaseddate > sysdate;

select * from rdd_subsystem; -- SUBSYSTEMID, ACCESSBITMASK

select * from rdd_validationtype; -- VALIDATIONTYPECODE

select * from rdd_passengertype;
--where ceaseddate > sysdate; -- PASSENGERTYPECODE/KEY

select * from rdd_transactionlocation
where locationtype = 0
and sysdate < ceaseddate;

select * from rdd_transactionlocation
where locationno = 109
and sysdate < ceaseddate;

select * from rdd_transactionlocation
where locationname like '%King St%'
and nlc in (940); -- LOCATION NUMBER

select * from rdd_device where locationno in (7,9) order by ceaseddate desc;

select * from rdd_discountentitlement
where ceaseddate > sysdate; -- DISCOUNTENTITLEMENTCODE/KEY

select * from rdd_devicetype;

select * from rdd_distanceband; -- DISTANCEBANDCODE/KEY

select * from rdd_intermodaltransfertype; -- INTERMODALTRANSFERTYPECODE

select * from rdd_farecategory; -- FARECATEGORYKEY

select * from rdd_foudiscount; -- FOUDISCOUNTKEY

select * from rdd_transaction;

select * from rdd_paymentmethod;

select * from rdd_busoperator
order by subsystemid;

select * from rdd_transactionlocation
where ceaseddate > sysdate
and locationname like '%Dulwich Hill%'; -- FARECATEGORYKEY

select * from rdd_transactionlocation
where ceaseddate > sysdate
and locationno = 58; -- FARECATEGORYKEY

select * from rdd_transactionlocation
where ceaseddate > sysdate
and locationno = 53; -- FARECATEGORYKEY

select * from rdd_cardtype
where cardtypecode = 1
and '08/JUN/17' between effectivedate and ceaseddate; -- CARDTYPEKEY

select * from rdd_cardtype where cardtypekey = 806; -- CARDTYPEKEY

select * from rdd_farecategory
where sysdate between effectivedate and ceaseddate; -- FARECATEGORYKEY/CODE

select * from rdd_boardinglocation; -- BOARDINGLOCATIONKEY, NLC, STATIONKEY, LOCATIONNAME

select * from rdd_intermodaltransfertype; -- INTERMODALTRANSFERTYPECODE

select * from rdd_passengertype; -- PASSENGERTYPECODE, PASSENGERTYPEKEY

select * from rdd_boardinglocation where nlc in (823) order by ceaseddate desc; -- LOOKUP AN NLC

select * from rdd_transactionlocation where nlc in (942, 940) order by ceaseddate desc;

select * from rdd_validationtype where validationtypecode in 43;

select DAYKEY, SMARTCARDID, JOURNEYINDEX, JOURNEYID, FIRSTENTRYTIME, EXITTIME, TRANSPORTMODE, JOURNEYTYPE, discounttransfer, dailycapped, offpeakjourney, fulladjustment, discountedadjustment, foucount
from DD_JOURNEY_SEGMENT 
where daykey in 13289 and smartcardid in 3423086;
--and transportmode in ('RAIL');
