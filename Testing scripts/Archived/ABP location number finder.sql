-- SEARCH BY FULL NAME
select *
from ABP_MAIN.LOCALE
where DESCRIPTION like '%Bathurst%'
order by locale_id asc
;

-- SEARCH BY NLC
select *
from LOCALE
where LOCALEID = '936'
order by localeid desc
;

desc LOCALE;

select *
from ETS_BUS_ROUTE_VARIANT;