-- CMS QUERIES
select count (*) from cms_cil_pending;

select count (*) from cms_cil_pending where actiontype = 1;

select * from dd_card_activity where rownum <100;

select * from cms_cil_pending where rownum < 100;

select * from cms_cil_pending where smartcardid = 70013384
order by prexpirydate desc;
--where smartcardid in 70013464;

select * from cms_card
where rownum <= 100
and smartcardid = 70204571;

-- SILICONE QUERIES --
select * from cms_card_acquired where smartcardid = 70013385;

select * from cos.order_item_group where SMARTCARD_ID in (3085220700133859);

select * from cos.order_item where order_item_group_id in (1000093755);

select * from cms_card_acquired where smartcardid = 70013384;

select * from odr_cdsday;
