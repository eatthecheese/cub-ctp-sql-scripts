select *
from EMV.MRF_FILE
where merchantfileid > 22700
order by merchantfileloaddate desc;

select * from EMV.MRF_FILE_HEADER
where MERCHANTFILEID > 27258;

select * from EMV.MRF_MERCHANT_SETTLEMENT
where MERCHANTFILEHEADERID = 28758;

select * from EMV.MRF_TRANSACTION_DETAIL
where TRANSACTIONDATE like '%12/MAR/19%';

select *
from EMV.MRF_TERMINAL_HEADER
where MERCHANTFILEHEADERID = 28758;

select *
from EMV.BANKCARD_PAYMENT
where PGRETRIEVALREFNBR = '000023668435';

select *
from EMV.GRRCN_FILE
where
--rownum < 100
--and 
RECONCILIATIONFILEID > 580;
--and RECONCILIATIONFILELOADDTM like '%05/APR/19%';

select *
from EMV.GRRCN_FILE_HEADER
where RECONCILIATIONFILEID > 580
order by filecreationdate desc;

select *
from EMV.GRRCN_TXN
where
rownum < 100
and TRANSACTIONDATE like '%06/APR/19%'
;