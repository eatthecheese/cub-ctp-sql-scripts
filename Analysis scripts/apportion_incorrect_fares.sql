select tr.tripid, tr.transitaccountid, tr.entryoperatorid, tr.exitoperatorid, tr.entrystopid, tr.exitstopid, tr.CALCULATEDFEE * 0.01 as SAF_PAID,
(case when ram.apportionedoperatorid = '44' then '44 - Sydney Trains'
when  ram.apportionedoperatorid = '45' then '45 - NSW Trainlink'
when ram.apportionedoperatorid = '37' then '37 - Metro Trains Sydney'
when opr.ETSOPERATORID = '1' then '1 - Sydney Ferries'
when opr.ETSOPERATORID = '46' then '46 - Sydney Light Rail'
when opr.ETSOPERATORID = '38' then '38 - Newcastle Transport'
when rvt.ETSSUBSYSTEMID is not null then TO_CHAR(bso.ETSSUBSYSTEMID) || ' - ' || TO_CHAR(bso.ETSBUSOPERATORNAME)
else 'No idea'
end) as OPERATOR_NAME
from emv.TRIP tr
left join emv.ETS_RAIL_APPORTIONMENT_MATRIX ram on (tr.ENTRYSTOPID = ram.ENTRYNLC and tr.EXITSTOPID = ram.EXITNLC)
join emv.TAP tp on (tp.TAPID = tr.ENTRYTAPID)
left join emv.ETS_OPERATOR opr on (opr.NLC = tr.ENTRYSTOPID)
left join emv.ETS_BUS_ROUTE_VARIANT_V rvt on (tp.EMPLOYEEID = rvt.ETSBUSOPERATORID and tp.ROUTENUM = rvt.ROUTEVARIANT)
left join emv.ETS_BUS_OPERATOR_DETAIL_V bso on (bso.ETSSUBSYSTEMID = rvt.ETSSUBSYSTEMID and bso.ETSBUSOPERATORID = rvt.ETSBUSOPERATORID)
where tr.TRIPID in ( /* Insert TRIPIDs below */
8522117,
8522332
)
order by tripid asc;