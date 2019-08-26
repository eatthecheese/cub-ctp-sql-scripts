select daykey,smartcardid,journeyindex,journeyid,starttime,endtime,startsequenceno,endsequenceno,
transportmode,journeytype,originlocationname,destinationlocationname,ridesremaining
from dd_journey 
where smartcardid in (70201350) and daykey = 13295; -- DD Journey Validation
; -- DD Journey Validation

select DAYKEY, SMARTCARDID, JOURNEYINDEX, JOURNEYID, FIRSTENTRYTIME, EXITTIME, TRANSPORTMODE, JOURNEYTYPE, discounttransfer, dailycapped, offpeakjourney, fulladjustment, discountedadjustment, foucount
from DD_JOURNEY_SEGMENT 
where daykey in 13485 and smartcardid in 70701479;
--and transportmode in ('RAIL');

select *
from DD_JOURNEY_SEGMENT 
where daykey in 13293 and smartcardid in 70201349;
--and transportmode in ('RAIL');

select * from DD_JOURNEY where daykey in 13289 and smartcardid in 3423086;

select *
from DD_CARD_ACTIVITY
where daykey in 13289 and smartcardid in 3423086;

select daykey, smartcardid, receiveddaykey, transactiontype, svadded, transactiontime
from DD_CARD_TRANSACTION
--where smartcardid in 70020021
where daykey in 13671
and smartcardid like '%700766068%'
order by sequenceno desc;

select * from dd_card_transaction where transactiontype in (1,2,3,4,20) and smartcardid in (
700765319
) order by smartcardid desc, transactiontype asc ;
--Product creation validation (Ensure 4 transactions per card). Purse cards will not have TransactionType 20. STT Tickets with 1 day life will have TransactionType 4. 

select * from cdsprod1.TDM_RTD_CARD_ISSUE 
where smartcardid = 70013645; 


select daykey, sequenceno, locationnamefull, transactiontype, validationtypecode
from DD_CARD_TRANSACTION
where daykey in 13659 and smartcardid in 70013460
order by sequenceno;

select * 
from odr_raloutqueuemsg
where rownum <=100
and timestamp = sysdate
order by timestamp desc;
--and filename like '%tra_13660%';
--order by receipttime desc;

select *
from cms_card
where smartcardid in (70201204);

select *
from odr_inputfiles
where rownum <= 200
--and filestatus = 6
and filename like '%tra_13735%'
order by filename desc;

select sequenceno, locationnamefull,transactiontype, svadded, svbalance, discountintermodal, intermodalfarereduction
from dd_card_transaction