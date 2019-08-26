desc abp_staging.FLEX_LOAD_LOG;

select fll.schema_name, fll.table_name, fll.file_name, fll.extract_dtm, fll.data_begin_dtm, fll.data_end_dtm, fll.load_begin_dtm,
fll.load_end_dtm, fll.rows_loaded, fll.status, fll.messages, fll.file_deleted_flag, fll.nbr_retries
from abp_staging.FLEX_LOAD_LOG fll
where fll.load_begin_dtm between TO_DATE('16/AUG/2019 07:00:00', 'DD/MM/YYYY HH24:MI:SS') and
TO_DATE('16/AUG/2019 14:00:00', 'DD/MM/YYYY HH24:MI:SS') 
and fll.TABLE_NAME = 'TAP'
order by fll.LOAD_BEGIN_DTM asc
;

select count(tp.tapid)
from emv.tap tp
where tp.TRANSACTIONDTM between TO_DATE('16/AUG/2019 07:00:00', 'DD/MM/YYYY HH24:MI:SS') and
TO_DATE('16/AUG/2019 14:00:00', 'DD/MM/YYYY HH24:MI:SS') 
;