select count(*)
from cdsprod1.dd_journey_segment 
where daykey = 14340
and WEEKLYCAPPED = 'Y'
;

select ENTRYTIMESTAMP, OFFPEAKJOURNEY
from cdsprod1.dd_journey_segment
where 
daykey = 14340
and FIRSTENTRYTIME = 539
;

select *
from cdsprod1.dd_journey_segment
where 
daykey = 14340
and rownum < 25; 

-- PLAYGROUND
-- Find all journey segments where
-- Location Tap On == Manly || CQ3
-- Location Tap Off == Manly || CQ3
-- Delta Time of Tap On/Off > 30 mins
-- Card Type == Purse

select a.daykey, a.smartcardid, a.*
from CDSPROD1.DD_JOURNEY_SEGMENT a
where daykey > sysdate - 60  -- last 60 days
and daykey < 14385 -- 14384 = Monday 20/05/19
and origintsn = 936 -- 936 for CQ3, 939 for Manly
and destinationtsn = 936
--and exittime > firstentrytime + 30
;

select *
from CDSPROD1.RDD_BOARDINGLOCATION
where NLC in (939, 936)
and sysdate < ceaseddate;


desc cdsprod1.dd_journey_segment;
desc cdsprod1.tdm_rtd_header;

select trh.TRPRECEIVEDDAYKEY,trh.RECEIVEDDAYKEY, trh.RECEIVEDUTSTIME, trh.DAYKEY, trh.TRANSACTIONDATE, trh.HOSTNLC
from cdsprod1.tdm_rtd_header trh
where trh.DAYKEY = 14451
and trh.HOSTNLC = '281'
;

--DD_JOURNEY_SEGMENT
SELECT daykey, ENTRYTIMESTAMP, journeyid, transportmode, smartcardid, foucount, foudiscountkey, ORIGINTSN, DESTINATIONTSN, 
journeytype, originlocationname, destinationlocationname, fulladjustment, discountedadjustment, saf, starttransactiontype, endtransactiontype
from cdsprod1.dd_journey_segment
where daykey = 14451
and origintsn = '281'
order by ENTRYTIMESTAMP asc
;
--and daykey = 13959; -- DD_JOURNEY_SEGMENT validation

-- LOWBALWARNING QUERIES
------------------------
select daykey, sequenceno, CARDTYPEKEY, transportmode, LOCATIONNAME, SVADDED, SVBALANCE, TRANSACTIONTYPE, VALIDATIONRESULTKEY, VALIDATIONRESULTCODE, VALIDATIONTYPECODE, TRANSACTIONTIMESTAMP, devicekey, TRANSACTIONDETERMINATE, DAILYCAPPED
from dd_card_transaction
where smartcardid = 70204571
order by sequenceno desc;

------------------------
select *
from dd_card_transaction
where daykey = 14177 and 
smartcardid = 70013282 
order by sequenceno desc;

select * from dd_card_transaction where smartcardid = 700767372 and devicetypecode = 10 order by sequenceno asc;

select * from tds_rtd_header where locationname like '%SEU%' and daykey = 14203 order by sequenceno asc;

select count (*) from dd_card_transaction where transactiontype = 1 and transactiondate in (14108) and devicetypecode = 10;
select smartcardid from dd_card_transaction where transactiontype = 2 and transactiondate in (14108) and devicetypecode = 10; order by smartcardid asc;

select *
from dd_card_transaction
where daykey = 14247 and 
smartcardid = 70013328
order by sequenceno desc;

select * from dd_card_transaction where locationname = 'Cubic Test 23' and daykey = 14066
order by transactiontime asc;

select t.lowbalancewarning, t.svbalance, t.* from tds_rtd_tag_on_sv t where lowbalancewarning = 'N' and daykey >= 13850 and rownum <= 100 and svbalance <= 600 and validationresultcode = 0;

select t.LOWBALANCEWARNING, t.SVBALANCE, t.* from tdm_rtd_tag_on_sv t where lowbalancewarning = 'N' and daykey >= 13850 and rownum <= 100 and svbalance <= 600 and validationresultcode = 0;

select t.LOWBALANCEWARNING, t.* from tds_rtd_tag_off_sv t where smartcardid = 70204181 and daykey = 13894;


select a.smartcardid, b.batchid,a.transactiontype,b.filename,b.filestatus,c.rtdtransactiontypename
from dd_card_transaction a inner join odr_inputfiles b on a.batchid=b.batchid 
inner join rdd_rtdtransactiontype c on a.transactiontype = c.rtdtransactiontypecode 
where a.smartcardid=700766517;

select * from dd_card_transaction where smartcardid = 70605330 and rownum <= 100 order by batchid asc;
select * from dd_card_transaction where smartcardid = 70013280 and daykey = 13993 order by batchid asc;

select rtdid from dd_card_transaction where devicetypecode = 10 and daykey > 13900 and rownum <= 100;

select *
from dd_journey_segment
where smartcardid in (70202422)
and daykey = 13861; -- DD_JOURNEY_SEGMENT validation

select * from dd_card_activity
where smartcardid in (70202276)
and daykey = 13888
order by activityid desc; -- Activity Statement Validation

SELECT svbalance, cardtypekey, transactiontype, foudiscountkey, discountfou, offpeakjourney, locationname, foucount, distancebandstraveled, intermodaltransfertypecode, distancebandcode, validationtypecode, dd_card_transaction.*
from dd_card_transaction
where smartcardid in 70014258
and daykey = 14045
--and transactiontype = 46
--and locationname = 'Domestic'
order by sequenceno asc;
--and daykey in 13434; -- DD_JOURNEY_SEGMENT validation

select * from dd_card_transaction where  smartcardid in 70014433;

select * from opg.payment where rownum <= 100;

select * from dd_card_activity where smartcardid in (70201204)
and daykey = 13751;

SELECT *
from dd_journey_segment a
where smartcardid in (70201204)
and daykey = 13751
and transportmode in 'RAIL'
and startsequenceno in 80
and endsequenceno in 81;

select *
from odr_inputfiles
where
--rownum <= 100
transferdate = 14184 and
 filename like '%tra_14184%'
--and transfernumber = 32
order by filename desc;

select *
from odr_inputfiles
where
--rownum <= 100
transferdate = 14105 and
 filename like '%tra_14105%'
--and transfernumber = 32
order by filename desc;

select * From odr_inputfiles where filename like '%tra_13951_0032%' order by batchid desc;

select * from tds_rtd_header where batchid=2829093;
select * from dd_card_transaction where batchid=2829093; 

