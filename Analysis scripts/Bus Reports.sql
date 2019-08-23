select *
from DD_CARD_TRANSACTION
where rownum < 100;

select daykey, smartcardid, sequenceno, transactiontype, svadded, tsn, transactiontime, routevariantkey, busstopkey, busoperatorid, transportmode, transactionlocationkey, locationname, foucount, boardinglocationkey, routevariant, journeyindex, segmentindex, busoperatorkey, 
busdepotkey, depotid, busid, driverid, shiftid, busdriverconsoleid, busvalidatorposition, firstentrylocationkey, alightinglocationkey, firstentrylocationname
from DD_CARD_TRANSACTION
where rownum < 100
and smartcardid = 70204162
and daykey = 14029
and transactiontype in (45, 46, 47) -- 45 = Bus Tap On, 46 = Bus Tap Off, 47 = Bus Tap On Reversal
order by sequenceno asc
;

select js.busdepotkey, js.busid, js.*
from DD_JOURNEY_SEGMENT js
where rownum < 100
and smartcardid = 70013184
and daykey = 14027
;

select * from CDSPROD1.DD_CARD_ACTIVITY
where smartcardid = 17281956
and daykey = 14337
;

-- Number of Bus journey segments in a day where travel time is larger than 4 hours
with BUS_JOURNEYS as (
    select a.*
    from CDSPROD1.DD_JOURNEY_SEGMENT a
    where transportmode = 'BUS'
    and routevariant not like '%Stkn%' -- EXCLUDE STOCKTON FERRY
    and daykey = 14332 -- EDIT THIS FOR DAYKEY
    and journeytype not like ('REV') -- EXCLUDE REVERSALS
    and starttransactiontype = 45 -- ONLY PURSE CARDS (54 for PRODUCTS)
)
select 
--js.daykey, js.smartcardid, js.entrytimestamp, js.exittimestamp, js.segmentid, js.busid, js.busdepotkey, js.routevariant, js.origintsn, js.destinationtsn, js.startsequenceno, js.endsequenceno,
--js.transportmode, js.journeytype, js.originlocationname, js.destinationlocationname, js.foucount, js.originlocationkey, js.destinationlocationkey,
--js.fulladjustment, js.discountedadjustment, js.starttransactiontype, js.endtransactiontype, js.cardtypekey, js.subsystemid
count(*)
from BUS_JOURNEYS js
where EXITTIME > ENTRYTIME + 1*60
;

select * from CDSPROD1.DD_CARD_ACTIVITY
where DAYKEY = 14027
and SMARTCARDID = 16520798
;

select * from CDSPROD1.TDM_RTD_HEADER
where DAYKEY = 14334
and rownum < 100
;

select * from CDSPROD1.TDS_RTD_HEADER
where DAYKEY = 14027
and SMARTCARDID = 16503968
;

select * from CDSPROD1.RDD_TRANSACTIONSUBTYPE;
-- 45 = Bus Purse Tap on
-- 46 = Bus Purse Tap off
-- 54 = Bus Ticket Tap on
-- 55 = Bus Ticket Tap off

-- Report to find all bus trips (journey segments) made on the same card on the same bus for a specific daykey
select js.daykey, js.smartcardid, js.entrytimestamp, js.exittimestamp, js.segmentid, js.busid, js.busdepotkey, js.routevariant, js.origintsn, js.destinationtsn, js.startsequenceno, js.endsequenceno,
js.transportmode, js.journeytype, js.originlocationname, js.destinationlocationname, js.foucount, js.originlocationkey, js.destinationlocationkey,
js.fulladjustment, js.discountedadjustment, js.starttransactiontype, js.endtransactiontype, js.cardtypekey, js.subsystemid
from DD_JOURNEY_SEGMENT js
where (
    select count(*)
    from DD_JOURNEY_SEGMENT b
    where js.smartcardid = b.smartcardid
    and js.busid = b.busid
    and js.busdepotkey = b.busdepotkey
    and js.daykey = b.daykey
    and js.transportmode = 'BUS'
    and js.daykey = 14027   -- EDIT THIS FOR DAYKEY
    and js.journeytype not like ('REV') -- EXCLUDE REVERSALS
) > 1
order by smartcardid
;

select * from CDSPROD1.DD_CARD_ACTIVITY
where DAYKEY = 14334
and smartcardid = 24143131
order by activitystarttime asc
; 

select js.daykey, js.smartcardid, js.segmentindex, js.entrytimestamp, js.entrytime, js.exittimestamp, js.exittime, js.segmentid, js.busid, js.busdepotkey, js.routevariant, js.origintsn, js.destinationtsn, js.startsequenceno, js.endsequenceno,
js.transportmode, js.journeytype, js.originlocationname, js.destinationlocationname, js.foucount, js.originlocationkey, js.destinationlocationkey,
js.fulladjustment, js.discountedadjustment, js.starttransactiontype, js.endtransactiontype, js.cardtypekey, js.subsystemid
from CDSPROD1.DD_JOURNEY_SEGMENT js
where js.DAYKEY = 14330
and js.smartcardid = 100873683
order by firstentrytime asc
; 

-- 1. NUMBER OF IMPLIED TRANSFERS (PURSE ONLY)
with ALL_BUS_TAP_ONS as (
    SELECT a.daykey, a.smartcardid, a.sequencenocard, a.busid, a.depotid, a.driverid, a.shiftid, a.transactiontype, b.validationresultcode, b.validationtypecode, a.routevariant,
    a.locationname, a.transportmode, a.svadded, a.svbalance, b.fullentryadjustment, b.entryadjustment, b.transferflagentry, b.firstentrytime, b.batchid, b.filerecordno, b.position
    from CDSPROD1.tdm_rtd_header a, CDSPROD1.tdm_rtd_tag_ON_bus_sv b
    where a.daykey = 14334
    and a.transactiontype = 45
    and (a.daykey=b.daykey)
    and (b.batchid=a.batchid and b.filerecordno=a.filerecordno
    and b.position=a.position and b.smartcardid=a.smartcardid)
    order by a.smartcardid desc, a.sequencenocard asc -- Tap on for Bus Purse Fare Logic
), 
BUS_JOURNEYS as (
    select a.*
    from CDSPROD1.DD_JOURNEY_SEGMENT a
    where transportmode = 'BUS'
    and routevariant not like '%Stkn%' -- EXCLUDE STOCKTON FERRY
    and daykey = 14334 -- EDIT THIS FOR DAYKEY
    and journeytype not like ('REV') -- EXCLUDE REVERSALS
),
IMPLIED_TRANSFER_JOURNEYS as (
    select a.*
    from BUS_JOURNEYS a
    where exists (
        select 1
        from ALL_BUS_TAP_ONS b
        where b.daykey = a.daykey
        and b.smartcardid = a.smartcardid
        and b.sequencenocard = a.segmentid
        and b.routevariant <> a.routevariant
    )
)
select count(*)
from IMPLIED_TRANSFER_JOURNEYS
;

-- 2. CUSTOMERS THAT TRAVEL ON THE SAME BUS IN A SINGLE DAY WHERE EACH JOURNEY SEGMENT IS AT LEAST 4 HOURS APART:
with BUS_JOURNEYS as (
    select a.*
    from CDSPROD1.DD_JOURNEY_SEGMENT a
    where transportmode = 'BUS'
    and routevariant not like '%Stkn%' -- EXCLUDE STOCKTON FERRY
    and daykey = 14337 -- EDIT THIS FOR DAYKEY
    and journeytype not like ('REV') -- EXCLUDE REVERSALS
    and starttransactiontype = 45 -- ONLY PURSE CARDS (54 for PRODUCTS)
),
SAME_BUS_JOURNEYS as (
    select 
    js.daykey, js.smartcardid, js.segmentindex, js.entrytimestamp, js.entrytime, js.exittimestamp, js.exittime, js.segmentid, js.busid, js.busdepotkey, js.routevariant, js.origintsn, js.destinationtsn, js.startsequenceno, js.endsequenceno,
    js.transportmode, js.journeytype, js.originlocationname, js.destinationlocationname, js.foucount, js.originlocationkey, js.destinationlocationkey,
    js.fulladjustment, js.discountedadjustment, js.starttransactiontype, js.endtransactiontype, js.cardtypekey, js.subsystemid
    from BUS_JOURNEYS js
    where exists (
        select 1
        from BUS_JOURNEYS b
        where js.segmentid <> b.segmentid
        and js.smartcardid = b.smartcardid
        and js.busid = b.busid
        and js.busdepotkey = b.busdepotkey
        and js.daykey = b.daykey
    )
)
select
*
from SAME_BUS_JOURNEYS sbj
;

-- 2A2
with BUS_JOURNEYS as (
    select a.*
    from CDSPROD1.DD_JOURNEY_SEGMENT a
    where transportmode = 'BUS'
    and routevariant not like '%Stkn%' -- EXCLUDE STOCKTON FERRY
    and daykey = 14330 -- EDIT THIS FOR DAYKEY
    and journeytype not like ('REV') -- EXCLUDE REVERSALS
    --and starttransactiontype = 45 -- ONLY PURSE CARDS (54 for PRODUCTS)
), SAME_BUS_JOURNEYS as (
    select 
    js.daykey, js.smartcardid, js.segmentindex, js.entrytimestamp, js.entrytime, js.exittimestamp, js.exittime, js.segmentid, js.busid, js.busdepotkey, js.routevariant, js.origintsn, js.destinationtsn, js.startsequenceno, js.endsequenceno,
    js.transportmode, js.journeytype, js.originlocationname, js.destinationlocationname, js.foucount, js.originlocationkey, js.destinationlocationkey,
    js.fulladjustment, js.discountedadjustment, js.starttransactiontype, js.endtransactiontype, js.cardtypekey, js.subsystemid
    from BUS_JOURNEYS js
    where exists (
        select 1
        from BUS_JOURNEYS b
        where js.segmentid <> b.segmentid
        and js.smartcardid = b.smartcardid
        and js.busid = b.busid
        and js.busdepotkey = b.busdepotkey
        and js.daykey = b.daykey
        --and js.journeytype = 'UNF' -- only include journey segments where the customer has done the wrong thing
    )
) 
select 
--*
count(*)
from SAME_BUS_JOURNEYS sbj
where exists (
    select 1
    from SAME_BUS_JOURNEYS b
    where sbj.segmentid <> b.segmentid
    and sbj.entrytime > b.entrytime + 4*60 -- find journey segments where the time between entry taps is > 4hrs
    and sbj.segmentindex = b.segmentindex + 1 -- only include bus journey segments which are consecutive (i.e. no travel activity in between)
    and sbj.smartcardid = b.smartcardid
    and sbj.busid = b.busid
    and sbj.busdepotkey = b.busdepotkey
    and sbj.daykey = b.daykey
)
;

-- 3. CARDS THAT TRAVEL ON THE SAME BUS IN A SINGLE DAY, WITH DEFAULT FARES:
with BUS_JOURNEYS as (
    select a.*
    from CDSPROD1.DD_JOURNEY_SEGMENT a
    where transportmode = 'BUS'
    and routevariant not like '%Stkn%' -- EXCLUDE STOCKTON FERRY
    and daykey = 14330 -- EDIT THIS FOR DAYKEY
    and journeytype not like ('REV') -- EXCLUDE REVERSALS
    --and starttransactiontype = 45 -- ONLY PURSE CARDS (54 for PRODUCTS)
), SAME_BUS_JOURNEYS as (
    select 
    js.daykey, js.smartcardid, js.segmentindex, js.entrytimestamp, js.entrytime, js.exittimestamp, js.exittime, js.segmentid, js.busid, js.busdepotkey, js.routevariant, js.origintsn, js.destinationtsn, js.startsequenceno, js.endsequenceno,
    js.transportmode, js.journeytype, js.originlocationname, js.destinationlocationname, js.foucount, js.originlocationkey, js.destinationlocationkey,
    js.fulladjustment, js.discountedadjustment, js.starttransactiontype, js.endtransactiontype, js.cardtypekey, js.subsystemid
    from BUS_JOURNEYS js
    where exists (
        select 1
        from BUS_JOURNEYS b
        where js.segmentid <> b.segmentid
        and js.smartcardid = b.smartcardid
        and js.busid = b.busid
        and js.busdepotkey = b.busdepotkey
        and js.daykey = b.daykey
        and js.journeytype = 'UNF' -- only include journey segments where the customer has done the wrong thing
    )
) 
select 
--*
count(*)
from SAME_BUS_JOURNEYS sbj
where exists (
    select 1
    from SAME_BUS_JOURNEYS b
    where sbj.segmentid <> b.segmentid
    and sbj.entrytime > b.entrytime + 4*60 -- find journey segments where the time between entry taps is > 4hrs
    and sbj.segmentindex = b.segmentindex + 1 -- only include bus journey segments which are consecutive (i.e. no travel activity in between)
    and sbj.smartcardid = b.smartcardid
    and sbj.busid = b.busid
    and sbj.busdepotkey = b.busdepotkey
    and sbj.daykey = b.daykey
)
;

with BUS_JOURNEYS as (
  select a.*
  from cdsprod1.DD_JOURNEY_SEGMENT a
  where transportmode = 'BUS'
  and daykey = 14027 -- EDIT THIS FOR DAYKEY
  and journeytype not like ('REV') -- EXCLUDE REVERSALS
)
select 
count(*)
from BUS_JOURNEYS js
where exists (
  select 1
  from BUS_JOURNEYS b
  where js.segmentid <> b.segmentid
  and js.smartcardid = b.smartcardid
  and js.busid = b.busid
  and js.busdepotkey = b.busdepotkey
  and js.daykey = b.daykey
)
;


-- RUN FOR PROD
with BUS_JOURNEYS as (
    select a.*
    from DD_JOURNEY_SEGMENT a
    where transportmode = 'BUS'
    and daykey = 14027 -- EDIT THIS FOR DAYKEY
    and smartcardid in ('70204142', '3703')
    and journeytype not like ('REV') -- EXCLUDE REVERSALS
)
select 
*
from BUS_JOURNEYS js
where exists (
    select 1
    from BUS_JOURNEYS b
    where js.segmentid <> b.segmentid
    and js.smartcardid = b.smartcardid
    and js.busid = b.busid
    and js.busdepotkey = b.busdepotkey
    and js.daykey = b.daykey
)
;

-- VERSION 2 WIP
with BUS_JOURNEYS as (
    select a.*
    from DD_JOURNEY_SEGMENT a
    where transportmode = 'BUS'
    and origintsn <> -1
    and destinationtsn <> -1
    and daykey = 14027 -- EDIT THIS FOR DAYKEY
    and journeytype not like ('REV') -- EXCLUDE REVERSALS
),
with BUS_JOURNEYS_FILTERED as (
    select js.daykey, js.smartcardid, js.entrytimestamp, js.entrytime, js.exittimestamp, js.exittime, js.segmentid, js.busid, js.busdepotkey, js.routevariant, js.origintsn, js.destinationtsn, js.startsequenceno, js.endsequenceno,
    js.transportmode, js.journeytype, js.originlocationname, js.destinationlocationname, js.foucount, js.originlocationkey, js.destinationlocationkey,
    js.fulladjustment, js.discountedadjustment, js.starttransactiontype, js.endtransactiontype, js.cardtypekey, js.subsystemid
    from BUS_JOURNEYS js
    where exists (
        select 1
        from BUS_JOURNEYS b
        where js.segmentid <> b.segmentid
        and js.smartcardid = b.smartcardid
        and js.busid = b.busid
        and js.busdepotkey = b.busdepotkey
        and js.daykey = b.daykey
    )
)
select * 
from BUS_JOURNEYS_FILTERED bjf
where 
;

select * from DD_JOURNEY_SEGMENT 
where TRANSPORTMODE = 'BUS'
and daykey = 13993 -- EDIT THIS FOR DAYKEY
--and journeytype not like ('REV') -- EXCLUDE REVERSALS
and smartcardid = 70013330
;

select count(*)
from DDJOURNEYSEGMENT b, JOURNEY_COMPARE js
where js.smartcardid = b.smartcardid
and js.busid = b.busid
and js.busdepotkey = b.busdepotkey
and js.daykey = b.daykey
and js.transportmode = 'BUS'
and js.daykey = 14027   -- EDIT THIS FOR DAYKEY
and js.journeytype not like ('UNF') -- EXCLUDE REVERSALS
;

select * from RDD_BUSDEPOT;


-- TEST QUERIES GO HERE --
select js.daykey, js.smartcardid, js.entrytimestamp, js.exittimestamp, js.segmentid, js.busid, js.busdepotkey, js.routevariant, js.origintsn, js.destinationtsn, js.startsequenceno, js.endsequenceno,
js.transportmode, js.journeytype, js.originlocationname, js.destinationlocationname, js.foucount, js.originlocationkey, js.destinationlocationkey,
js.fulladjustment, js.discountedadjustment, js.starttransactiontype, js.endtransactiontype, js.cardtypekey, js.subsystemid, 
js.busdriverconsoleid
from DD_JOURNEY_SEGMENT js
where rownum < 100
and transportmode = 'BUS'
and daykey = 14027
order by smartcardid asc
--order by entrytimestamp asc
;

select *
from CMS_CARD
where smartcardid = 70204162;

select  *
from RDD_SUBSYSTEM;

select *
from RDD_TRANSACTIONSUBTYPE;