--on ABP_Prod
-- get current day of the week
with dow as (
    select 
       to_char(sysdate,'DAY',
       'NLS_DATE_LANGUAGE=''numeric date language''') dayoftheweek
    from dual
),
-- get last monday (up 6 for 1 week, up to)
StartDate as (
    select 
        trunc(sysdate,'DD')-6 -(select * from dow) startdate
    from dual
),
deny_list_detailed as (
    select 
            t3.tap_id, 
            t3.token_id,
            t3.transit_account_id,
            t3.stop_id,
            t3.prev_tap_id,
            t3.prev_tap_status_id, 
            t3.prev_transaction_dtm, 
            t3.prevdiff, 
            t3.prev_stop_id,
            t3.tap_status_id, 
            t3.transaction_dtm,
            t3.next_tap_id,
            t3.next_tap_status_id,
            t3.next_transaction_dtm,
            t3.next_stop_id,
            t.default_fare_flag as default_fare,
            t.fare_due,
            CASE t3.stop_id
              WHEN '11' THEN '1 - Sydney Ferries'
              WHEN '100' THEN '44 - Sydney Trains'
              WHEN '101' THEN '44 - Sydney Trains'
              WHEN '102' THEN '44 - Sydney Trains'
              WHEN '103' THEN '44 - Sydney Trains'
              WHEN '104' THEN '44 - Sydney Trains'
              WHEN '105' THEN '44 - Sydney Trains'
              WHEN '106' THEN '44 - Sydney Trains'
              WHEN '107' THEN '44 - Sydney Trains'
              WHEN '108' THEN '44 - Sydney Trains'
              WHEN '109' THEN '44 - Sydney Trains'
              WHEN '120' THEN '45 - NSW TrainLink'
              WHEN '121' THEN '45 - NSW TrainLink'
              WHEN '122' THEN '44 - Sydney Trains'
              WHEN '123' THEN '44 - Sydney Trains'
              WHEN '124' THEN '44 - Sydney Trains'
              WHEN '125' THEN '44 - Sydney Trains'
              WHEN '127' THEN '44 - Sydney Trains'
              WHEN '128' THEN '44 - Sydney Trains'
              WHEN '129' THEN '45 - NSW TrainLink'
              WHEN '130' THEN '45 - NSW TrainLink'
              WHEN '131' THEN '45 - NSW TrainLink'
              WHEN '140' THEN '45 - NSW TrainLink'
              WHEN '141' THEN '44 - Sydney Trains'
              WHEN '142' THEN '44 - Sydney Trains'
              WHEN '144' THEN '44 - Sydney Trains'
              WHEN '145' THEN '45 - NSW TrainLink'
              WHEN '146' THEN '44 - Sydney Trains'
              WHEN '147' THEN '45 - NSW TrainLink'
              WHEN '148' THEN '45 - NSW TrainLink'
              WHEN '149' THEN '44 - Sydney Trains'
              WHEN '150' THEN '44 - Sydney Trains'
              WHEN '151' THEN '45 - NSW TrainLink'
              WHEN '152' THEN '44 - Sydney Trains'
              WHEN '153' THEN '44 - Sydney Trains'
              WHEN '154' THEN '44 - Sydney Trains'
              WHEN '155' THEN '44 - Sydney Trains'
              WHEN '157' THEN '45 - NSW TrainLink'
              WHEN '158' THEN '44 - Sydney Trains'
              WHEN '159' THEN '45 - NSW TrainLink'
              WHEN '160' THEN '45 - NSW TrainLink'
              WHEN '161' THEN '45 - NSW TrainLink'
              WHEN '162' THEN '45 - NSW TrainLink'
              WHEN '163' THEN '45 - NSW TrainLink'
              WHEN '164' THEN '45 - NSW TrainLink'
              WHEN '165' THEN '45 - NSW TrainLink'
              WHEN '166' THEN '45 - NSW TrainLink'
              WHEN '167' THEN '44 - Sydney Trains'
              WHEN '168' THEN '45 - NSW TrainLink'
              WHEN '169' THEN '45 - NSW TrainLink'
              WHEN '170' THEN '45 - NSW TrainLink'
              WHEN '171' THEN '45 - NSW TrainLink'
              WHEN '180' THEN '44 - Sydney Trains'
              WHEN '181' THEN '44 - Sydney Trains'
              WHEN '182' THEN '44 - Sydney Trains'
              WHEN '183' THEN '44 - Sydney Trains'
              WHEN '184' THEN '44 - Sydney Trains'
              WHEN '185' THEN '44 - Sydney Trains'
              WHEN '186' THEN '44 - Sydney Trains'
              WHEN '187' THEN '44 - Sydney Trains'
              WHEN '188' THEN '44 - Sydney Trains'
              WHEN '189' THEN '44 - Sydney Trains'
              WHEN '190' THEN '44 - Sydney Trains'
              WHEN '191' THEN '44 - Sydney Trains'
              WHEN '192' THEN '44 - Sydney Trains'
              WHEN '193' THEN '44 - Sydney Trains'
              WHEN '194' THEN '44 - Sydney Trains'
              WHEN '195' THEN '45 - NSW TrainLink'
              WHEN '197' THEN '44 - Sydney Trains'
              WHEN '198' THEN '45 - NSW TrainLink'
              WHEN '199' THEN '45 - NSW TrainLink'
              WHEN '200' THEN '45 - NSW TrainLink'
              WHEN '201' THEN '45 - NSW TrainLink'
              WHEN '202' THEN '44 - Sydney Trains'
              WHEN '203' THEN '44 - Sydney Trains'
              WHEN '204' THEN '45 - NSW TrainLink'
              WHEN '205' THEN '45 - NSW TrainLink'
              WHEN '206' THEN '45 - NSW TrainLink'
              WHEN '208' THEN '45 - NSW TrainLink'
              WHEN '209' THEN '45 - NSW TrainLink'
              WHEN '210' THEN '44 - Sydney Trains'
              WHEN '211' THEN '44 - Sydney Trains'
              WHEN '220' THEN '45 - NSW TrainLink'
              WHEN '221' THEN '44 - Sydney Trains'
              WHEN '222' THEN '45 - NSW TrainLink'
              WHEN '223' THEN '44 - Sydney Trains'
              WHEN '224' THEN '44 - Sydney Trains'
              WHEN '225' THEN '45 - NSW TrainLink'
              WHEN '226' THEN '44 - Sydney Trains'
              WHEN '227' THEN '45 - NSW TrainLink'
              WHEN '228' THEN '44 - Sydney Trains'
              WHEN '229' THEN '45 - NSW TrainLink'
              WHEN '230' THEN '44 - Sydney Trains'
              WHEN '231' THEN '44 - Sydney Trains'
              WHEN '232' THEN '44 - Sydney Trains'
              WHEN '233' THEN '44 - Sydney Trains'
              WHEN '234' THEN '44 - Sydney Trains'
              WHEN '235' THEN '44 - Sydney Trains'
              WHEN '236' THEN '44 - Sydney Trains'
              WHEN '237' THEN '45 - NSW TrainLink'
              WHEN '239' THEN '45 - NSW TrainLink'
              WHEN '240' THEN '44 - Sydney Trains'
              WHEN '241' THEN '45 - NSW TrainLink'
              WHEN '242' THEN '45 - NSW TrainLink'
              WHEN '243' THEN '44 - Sydney Trains'
              WHEN '249' THEN '45 - NSW TrainLink'
              WHEN '250' THEN '45 - NSW TrainLink'
              WHEN '251' THEN '44 - Sydney Trains'
              WHEN '252' THEN '45 - NSW TrainLink'
              WHEN '253' THEN '45 - NSW TrainLink'
              WHEN '254' THEN '44 - Sydney Trains'
              WHEN '255' THEN '44 - Sydney Trains'
              WHEN '256' THEN '44 - Sydney Trains'
              WHEN '257' THEN '44 - Sydney Trains'
              WHEN '258' THEN '44 - Sydney Trains'
              WHEN '259' THEN '45 - NSW TrainLink'
              WHEN '260' THEN '44 - Sydney Trains'
              WHEN '261' THEN '45 - NSW TrainLink'
              WHEN '262' THEN '45 - NSW TrainLink'
              WHEN '263' THEN '45 - NSW TrainLink'
              WHEN '264' THEN '45 - NSW TrainLink'
              WHEN '265' THEN '44 - Sydney Trains'
              WHEN '266' THEN '45 - NSW TrainLink'
              WHEN '267' THEN '45 - NSW TrainLink'
              WHEN '268' THEN '44 - Sydney Trains'
              WHEN '269' THEN '45 - NSW TrainLink'
              WHEN '270' THEN '44 - Sydney Trains'
              WHEN '271' THEN '44 - Sydney Trains'
              WHEN '272' THEN '44 - Sydney Trains'
              WHEN '274' THEN '44 - Sydney Trains'
              WHEN '275' THEN '45 - NSW TrainLink'
              WHEN '280' THEN '44 - Sydney Trains'
              WHEN '281' THEN '44 - Sydney Trains'
              WHEN '290' THEN '44 - Sydney Trains'
              WHEN '300' THEN '45 - NSW TrainLink'
              WHEN '301' THEN '45 - NSW TrainLink'
              WHEN '302' THEN '45 - NSW TrainLink'
              WHEN '303' THEN '44 - Sydney Trains'
              WHEN '304' THEN '44 - Sydney Trains'
              WHEN '305' THEN '44 - Sydney Trains'
              WHEN '306' THEN '44 - Sydney Trains'
              WHEN '307' THEN '44 - Sydney Trains'
              WHEN '308' THEN '45 - NSW TrainLink'
              WHEN '309' THEN '45 - NSW TrainLink'
              WHEN '320' THEN '44 - Sydney Trains'
              WHEN '321' THEN '45 - NSW TrainLink'
              WHEN '322' THEN '45 - NSW TrainLink'
              WHEN '323' THEN '44 - Sydney Trains'
              WHEN '324' THEN '45 - NSW TrainLink'
              WHEN '325' THEN '44 - Sydney Trains'
              WHEN '326' THEN '44 - Sydney Trains'
              WHEN '328' THEN '44 - Sydney Trains'
              WHEN '330' THEN '45 - NSW TrainLink'
              WHEN '331' THEN '44 - Sydney Trains'
              WHEN '332' THEN '44 - Sydney Trains'
              WHEN '333' THEN '45 - NSW TrainLink'
              WHEN '334' THEN '44 - Sydney Trains'
              WHEN '335' THEN '45 - NSW TrainLink'
              WHEN '336' THEN '45 - NSW TrainLink'
              WHEN '337' THEN '45 - NSW TrainLink'
              WHEN '338' THEN '45 - NSW TrainLink'
              WHEN '339' THEN '45 - NSW TrainLink'
              WHEN '340' THEN '44 - Sydney Trains'
              WHEN '341' THEN '44 - Sydney Trains'
              WHEN '342' THEN '45 - NSW TrainLink'
              WHEN '343' THEN '44 - Sydney Trains'
              WHEN '344' THEN '44 - Sydney Trains'
              WHEN '345' THEN '44 - Sydney Trains'
              WHEN '346' THEN '45 - NSW TrainLink'
              WHEN '347' THEN '45 - NSW TrainLink'
              WHEN '348' THEN '45 - NSW TrainLink'
              WHEN '349' THEN '44 - Sydney Trains'
              WHEN '350' THEN '44 - Sydney Trains'
              WHEN '351' THEN '45 - NSW TrainLink'
              WHEN '352' THEN '44 - Sydney Trains'
              WHEN '353' THEN '44 - Sydney Trains'
              WHEN '354' THEN '45 - NSW TrainLink'
              WHEN '355' THEN '44 - Sydney Trains'
              WHEN '356' THEN '45 - NSW TrainLink'
              WHEN '357' THEN '45 - NSW TrainLink'
              WHEN '358' THEN '44 - Sydney Trains'
              WHEN '359' THEN '44 - Sydney Trains'
              WHEN '360' THEN '44 - Sydney Trains'
              WHEN '361' THEN '44 - Sydney Trains'
              WHEN '362' THEN '45 - NSW TrainLink'
              WHEN '363' THEN '44 - Sydney Trains'
              WHEN '364' THEN '44 - Sydney Trains'
              WHEN '365' THEN '45 - NSW TrainLink'
              WHEN '366' THEN '45 - NSW TrainLink'
              WHEN '370' THEN '44 - Sydney Trains'
              WHEN '372' THEN '44 - Sydney Trains'
              WHEN '373' THEN '45 - NSW TrainLink'
              WHEN '374' THEN '45 - NSW TrainLink'
              WHEN '375' THEN '44 - Sydney Trains'
              WHEN '376' THEN '44 - Sydney Trains'
              WHEN '377' THEN '44 - Sydney Trains'
              WHEN '378' THEN '45 - NSW TrainLink'
              WHEN '380' THEN '45 - NSW TrainLink'
              WHEN '385' THEN '45 - NSW TrainLink'
              WHEN '390' THEN '45 - NSW TrainLink'
              WHEN '391' THEN '44 - Sydney Trains'
              WHEN '392' THEN '45 - NSW TrainLink'
              WHEN '394' THEN '45 - NSW TrainLink'
              WHEN '398' THEN '45 - NSW TrainLink'
              WHEN '399' THEN '45 - NSW TrainLink'
              WHEN '400' THEN '44 - Sydney Trains'
              WHEN '401' THEN '44 - Sydney Trains'
              WHEN '402' THEN '44 - Sydney Trains'
              WHEN '403' THEN '44 - Sydney Trains'
              WHEN '404' THEN '44 - Sydney Trains'
              WHEN '405' THEN '44 - Sydney Trains'
              WHEN '406' THEN '44 - Sydney Trains'
              WHEN '407' THEN '44 - Sydney Trains'
              WHEN '408' THEN '45 - NSW TrainLink'
              WHEN '409' THEN '44 - Sydney Trains'
              WHEN '411' THEN '45 - NSW TrainLink'
              WHEN '412' THEN '45 - NSW TrainLink'
              WHEN '413' THEN '45 - NSW TrainLink'
              WHEN '414' THEN '44 - Sydney Trains'
              WHEN '415' THEN '44 - Sydney Trains'
              WHEN '420' THEN '44 - Sydney Trains'
              WHEN '430' THEN '44 - Sydney Trains'
              WHEN '431' THEN '44 - Sydney Trains'
              WHEN '432' THEN '44 - Sydney Trains'
              WHEN '433' THEN '44 - Sydney Trains'
              WHEN '434' THEN '44 - Sydney Trains'
              WHEN '435' THEN '44 - Sydney Trains'
              WHEN '436' THEN '44 - Sydney Trains'
              WHEN '437' THEN '44 - Sydney Trains'
              WHEN '438' THEN '44 - Sydney Trains'
              WHEN '439' THEN '44 - Sydney Trains'
              WHEN '440' THEN '44 - Sydney Trains'
              WHEN '442' THEN '44 - Sydney Trains'
              WHEN '443' THEN '45 - NSW TrainLink'
              WHEN '449' THEN '44 - Sydney Trains'
              WHEN '450' THEN '45 - NSW TrainLink'
              WHEN '451' THEN '44 - Sydney Trains'
              WHEN '452' THEN '44 - Sydney Trains'
              WHEN '454' THEN '45 - NSW TrainLink'
              WHEN '455' THEN '44 - Sydney Trains'
              WHEN '456' THEN '44 - Sydney Trains'
              WHEN '457' THEN '44 - Sydney Trains'
              WHEN '458' THEN '45 - NSW TrainLink'
              WHEN '459' THEN '45 - NSW TrainLink'
              WHEN '460' THEN '44 - Sydney Trains'
              WHEN '461' THEN '44 - Sydney Trains'
              WHEN '462' THEN '44 - Sydney Trains'
              WHEN '463' THEN '44 - Sydney Trains'
              WHEN '464' THEN '45 - NSW TrainLink'
              WHEN '465' THEN '44 - Sydney Trains'
              WHEN '466' THEN '45 - NSW TrainLink'
              WHEN '467' THEN '45 - NSW TrainLink'
              WHEN '468' THEN '45 - NSW TrainLink'
              WHEN '469' THEN '45 - NSW TrainLink'
              WHEN '470' THEN '45 - NSW TrainLink'
              WHEN '471' THEN '45 - NSW TrainLink'
              WHEN '472' THEN '45 - NSW TrainLink'
              WHEN '473' THEN '44 - Sydney Trains'
              WHEN '474' THEN '44 - Sydney Trains'
              WHEN '475' THEN '45 - NSW TrainLink'
              WHEN '476' THEN '45 - NSW TrainLink'
              WHEN '477' THEN '44 - Sydney Trains'
              WHEN '478' THEN '44 - Sydney Trains'
              WHEN '479' THEN '45 - NSW TrainLink'
              WHEN '481' THEN '45 - NSW TrainLink'
              WHEN '482' THEN '44 - Sydney Trains'
              WHEN '483' THEN '44 - Sydney Trains'
              WHEN '484' THEN '45 - NSW TrainLink'
              WHEN '485' THEN '45 - NSW TrainLink'
              WHEN '486' THEN '45 - NSW TrainLink'
              WHEN '490' THEN '45 - NSW TrainLink'
              WHEN '491' THEN '44 - Sydney Trains'
              WHEN '492' THEN '44 - Sydney Trains'
              WHEN '493' THEN '45 - NSW TrainLink'
              WHEN '499' THEN '45 - NSW TrainLink'
              WHEN '500' THEN '44 - Sydney Trains'
              WHEN '501' THEN '44 - Sydney Trains'
              WHEN '502' THEN '45 - NSW TrainLink'
              WHEN '503' THEN '45 - NSW TrainLink'
              WHEN '504' THEN '44 - Sydney Trains'
              WHEN '505' THEN '45 - NSW TrainLink'
              WHEN '506' THEN '44 - Sydney Trains'
              WHEN '507' THEN '44 - Sydney Trains'
              WHEN '508' THEN '44 - Sydney Trains'
              WHEN '509' THEN '45 - NSW TrainLink'
              WHEN '510' THEN '44 - Sydney Trains'
              WHEN '511' THEN '44 - Sydney Trains'
              WHEN '512' THEN '44 - Sydney Trains'
              WHEN '513' THEN '44 - Sydney Trains'
              WHEN '514' THEN '44 - Sydney Trains'
              WHEN '515' THEN '44 - Sydney Trains'
              WHEN '516' THEN '45 - NSW TrainLink'
              WHEN '517' THEN '45 - NSW TrainLink'
              WHEN '518' THEN '45 - NSW TrainLink'
              WHEN '519' THEN '45 - NSW TrainLink'
              WHEN '520' THEN '44 - Sydney Trains'
              WHEN '521' THEN '45 - NSW TrainLink'
              WHEN '522' THEN '45 - NSW TrainLink'
              WHEN '523' THEN '45 - NSW TrainLink'
              WHEN '524' THEN '45 - NSW TrainLink'
              WHEN '525' THEN '45 - NSW TrainLink'
              WHEN '526' THEN '44 - Sydney Trains'
              WHEN '527' THEN '45 - NSW TrainLink'
              WHEN '528' THEN '44 - Sydney Trains'
              WHEN '529' THEN '45 - NSW TrainLink'
              WHEN '540' THEN '44 - Sydney Trains'
              WHEN '544' THEN '44 - Sydney Trains'
              WHEN '545' THEN '45 - NSW TrainLink'
              WHEN '546' THEN '45 - NSW TrainLink'
              WHEN '547' THEN '45 - NSW TrainLink'
              WHEN '548' THEN '45 - NSW TrainLink'
              WHEN '549' THEN '45 - NSW TrainLink'
              WHEN '550' THEN '45 - NSW TrainLink'
              WHEN '551' THEN '45 - NSW TrainLink'
              WHEN '552' THEN '45 - NSW TrainLink'
              WHEN '553' THEN '45 - NSW TrainLink'
              WHEN '560' THEN '44 - Sydney Trains'
              WHEN '561' THEN '44 - Sydney Trains'
              WHEN '562' THEN '44 - Sydney Trains'
              WHEN '574' THEN '45 - NSW TrainLink'
              WHEN '581' THEN '37 - Metro Trains Sydney'
              WHEN '582' THEN '37 - Metro Trains Sydney'
              WHEN '583' THEN '37 - Metro Trains Sydney'
              WHEN '584' THEN '37 - Metro Trains Sydney'
              WHEN '585' THEN '37 - Metro Trains Sydney'
              WHEN '586' THEN '37 - Metro Trains Sydney'
              WHEN '587' THEN '37 - Metro Trains Sydney'
              WHEN '588' THEN '37 - Metro Trains Sydney'
              WHEN '625' THEN '44 - Sydney Trains'
              WHEN '626' THEN '44 - Sydney Trains'
              WHEN '801' THEN '46 - Sydney Light Rail'
              WHEN '802' THEN '46 - Sydney Light Rail'
              WHEN '803' THEN '46 - Sydney Light Rail'
              WHEN '804' THEN '46 - Sydney Light Rail'
              WHEN '805' THEN '46 - Sydney Light Rail'
              WHEN '806' THEN '46 - Sydney Light Rail'
              WHEN '807' THEN '46 - Sydney Light Rail'
              WHEN '808' THEN '46 - Sydney Light Rail'
              WHEN '809' THEN '46 - Sydney Light Rail'
              WHEN '810' THEN '46 - Sydney Light Rail'
              WHEN '811' THEN '46 - Sydney Light Rail'
              WHEN '812' THEN '46 - Sydney Light Rail'
              WHEN '813' THEN '46 - Sydney Light Rail'
              WHEN '814' THEN '46 - Sydney Light Rail'
              WHEN '815' THEN '46 - Sydney Light Rail'
              WHEN '816' THEN '46 - Sydney Light Rail'
              WHEN '817' THEN '46 - Sydney Light Rail'
              WHEN '818' THEN '46 - Sydney Light Rail'
              WHEN '819' THEN '46 - Sydney Light Rail'
              WHEN '820' THEN '46 - Sydney Light Rail'
              WHEN '821' THEN '46 - Sydney Light Rail'
              WHEN '822' THEN '46 - Sydney Light Rail'
              WHEN '823' THEN '46 - Sydney Light Rail'
              WHEN '853' THEN '38 - Newcastle Transport'
              WHEN '854' THEN '38 - Newcastle Transport'
              WHEN '855' THEN '38 - Newcastle Transport'
              WHEN '856' THEN '38 - Newcastle Transport'
              WHEN '857' THEN '38 - Newcastle Transport'
              WHEN '858' THEN '38 - Newcastle Transport'
              WHEN '935' THEN '1 - Sydney Ferries'
              WHEN '936' THEN '1 - Sydney Ferries'
              WHEN '937' THEN '1 - Sydney Ferries'
              WHEN '938' THEN '1 - Sydney Ferries'
              WHEN '939' THEN '1 - Sydney Ferries'
              WHEN '943' THEN '1 - Sydney Ferries'
              WHEN '944' THEN '1 - Sydney Ferries'
              WHEN '945' THEN '1 - Sydney Ferries'
              WHEN '946' THEN '1 - Sydney Ferries'
              WHEN '947' THEN '1 - Sydney Ferries'
              WHEN '948' THEN '1 - Sydney Ferries'
              WHEN '950' THEN '1 - Sydney Ferries'
              WHEN '952' THEN '1 - Sydney Ferries'
              WHEN '953' THEN '1 - Sydney Ferries'
              WHEN '954' THEN '1 - Sydney Ferries'
              WHEN '955' THEN '1 - Sydney Ferries'
              WHEN '956' THEN '1 - Sydney Ferries'
              WHEN '957' THEN '1 - Sydney Ferries'
              WHEN '958' THEN '1 - Sydney Ferries'
              WHEN '959' THEN '1 - Sydney Ferries'
              WHEN '960' THEN '1 - Sydney Ferries'
              WHEN '961' THEN '1 - Sydney Ferries'
              WHEN '962' THEN '1 - Sydney Ferries'
              WHEN '963' THEN '1 - Sydney Ferries'
              WHEN '964' THEN '1 - Sydney Ferries'
              WHEN '965' THEN '1 - Sydney Ferries'
              WHEN '968' THEN '1 - Sydney Ferries'
              WHEN '969' THEN '1 - Sydney Ferries'
              WHEN '970' THEN '1 - Sydney Ferries'
              WHEN '971' THEN '1 - Sydney Ferries'
              WHEN '972' THEN '1 - Sydney Ferries'
              WHEN '973' THEN '1 - Sydney Ferries'
              WHEN '974' THEN '1 - Sydney Ferries'
              WHEN '977' THEN '1 - Sydney Ferries'
              WHEN '979' THEN '1 - Sydney Ferries'
              WHEN '980' THEN '1 - Sydney Ferries'
              WHEN '981' THEN '1 - Sydney Ferries'
              WHEN '982' THEN '1 - Sydney Ferries'
              WHEN '983' THEN '1 - Sydney Ferries'
              WHEN '985' THEN '1 - Sydney Ferries'
              WHEN '9999' THEN '1 - Sydney Ferries'
        ELSE '404 - Not Found' END as apportioned_ETS_Operator
    from (
        select 
            tap_id, 
            token_id,
            transit_account_id,
            trip_id,
            stop_id,
            prev_tap_id,
            prev_tap_status_id, 
            prev_transaction_dtm+11/24 as prev_transaction_dtm, 
            SUBSTR((transaction_dtm-prev_transaction_dtm),1,30) as prevdiff, 
            prev_stop_id,
            tap_status_id, 
            transaction_dtm+11/24 as transaction_dtm,
            next_tap_id,
            next_tap_status_id,
            next_transaction_dtm+11/24 as next_transaction_dtm,
            next_stop_id
        from (
            select
                t1.tap_id,
                t1.device_id,
                t1.token_id,
                t1.trip_id,
                t1.transit_account_id,
                t1.stop_id,
                t1.tap_status_id,
                t1.TAP_STATUS_DESCRIPTION,
                t1.transaction_dtm,
                t1.ORIGINAL_TAP_STATUS_ID,
            LAG(tap_id) OVER (PARTITION BY token_id ORDER BY token_id, tap_id) AS prev_tap_id,
            LAG(tap_status_id) OVER (PARTITION BY token_id ORDER BY token_id, tap_id) AS prev_tap_status_id,
            LAG(transaction_dtm) OVER (PARTITION BY token_id ORDER BY token_id, tap_id) AS prev_transaction_dtm,
            LAG(stop_id) OVER (PARTITION BY token_id ORDER BY token_id, tap_id) AS prev_stop_id,
            LEAD(tap_id) OVER (PARTITION BY token_id ORDER BY token_id, tap_id) AS next_tap_id,
            LEAD(tap_status_id) OVER (PARTITION BY token_id ORDER BY token_id, tap_id) AS next_tap_status_id,
            LEAD(transaction_dtm) OVER (PARTITION BY token_id ORDER BY token_id, tap_id) AS next_transaction_dtm,
            LEAD(stop_id) OVER (PARTITION BY token_id ORDER BY token_id,tap_id) AS next_stop_id
            from abp_main.tap t1
            where transaction_dtm +11/24 >= trunc(sysdate-1, 'dd')+4/24  --replaced 20181206 based on email from Michael Tao
			AND transaction_dtm +11/24 < trunc(sysdate, 'dd')+4/24  --added 20181206 based on email from Michael Tao
            order by tap_id desc
        ) t2
        where 
        tap_status_id = 4
        and stop_id = prev_stop_id
        and ((prev_tap_status_id = 1 and next_tap_status_id = 4)
        OR (prev_tap_status_id = 1 and next_tap_status_id = 700)
        OR (prev_tap_status_id = 4 and next_tap_status_id = 700)
        OR (prev_tap_status_id = 1 and next_tap_status_id is null)
        OR (prev_tap_status_id = 4 and next_tap_status_id is null)
        )order by token_id, transaction_dtm asc
    ) t3
    right join abp_main.trip t
    on t3.prev_tap_id = t.entry_tap_id
    -- agreed to be 30
    where t3.prevdiff < INTERVAL '30' MINUTE 
    --and default_fare_flag = 1
),
-- get data set (UTC time)
data as (
    select 
        Trip_ID, 
        transit_account_id, 
        token_id,
        entry_transaction_DTM,
        entry_stop_ID,
        CASE entry_stop_id
            WHEN '11' THEN '1 - Sydney Ferries'
            WHEN '100' THEN '44 - Sydney Trains'
            WHEN '101' THEN '44 - Sydney Trains'
            WHEN '102' THEN '44 - Sydney Trains'
            WHEN '103' THEN '44 - Sydney Trains'
            WHEN '104' THEN '44 - Sydney Trains'
            WHEN '105' THEN '44 - Sydney Trains'
            WHEN '106' THEN '44 - Sydney Trains'
            WHEN '107' THEN '44 - Sydney Trains'
            WHEN '108' THEN '44 - Sydney Trains'
            WHEN '109' THEN '44 - Sydney Trains'
            WHEN '120' THEN '45 - NSW TrainLink'
            WHEN '121' THEN '45 - NSW TrainLink'
            WHEN '122' THEN '44 - Sydney Trains'
            WHEN '123' THEN '44 - Sydney Trains'
            WHEN '124' THEN '44 - Sydney Trains'
            WHEN '125' THEN '44 - Sydney Trains'
            WHEN '127' THEN '44 - Sydney Trains'
            WHEN '128' THEN '44 - Sydney Trains'
            WHEN '129' THEN '45 - NSW TrainLink'
            WHEN '130' THEN '45 - NSW TrainLink'
            WHEN '131' THEN '45 - NSW TrainLink'
            WHEN '140' THEN '45 - NSW TrainLink'
            WHEN '141' THEN '44 - Sydney Trains'
            WHEN '142' THEN '44 - Sydney Trains'
            WHEN '144' THEN '44 - Sydney Trains'
            WHEN '145' THEN '45 - NSW TrainLink'
            WHEN '146' THEN '44 - Sydney Trains'
            WHEN '147' THEN '45 - NSW TrainLink'
            WHEN '148' THEN '45 - NSW TrainLink'
            WHEN '149' THEN '44 - Sydney Trains'
            WHEN '150' THEN '44 - Sydney Trains'
            WHEN '151' THEN '45 - NSW TrainLink'
            WHEN '152' THEN '44 - Sydney Trains'
            WHEN '153' THEN '44 - Sydney Trains'
            WHEN '154' THEN '44 - Sydney Trains'
            WHEN '155' THEN '44 - Sydney Trains'
            WHEN '157' THEN '45 - NSW TrainLink'
            WHEN '158' THEN '44 - Sydney Trains'
            WHEN '159' THEN '45 - NSW TrainLink'
            WHEN '160' THEN '45 - NSW TrainLink'
            WHEN '161' THEN '45 - NSW TrainLink'
            WHEN '162' THEN '45 - NSW TrainLink'
            WHEN '163' THEN '45 - NSW TrainLink'
            WHEN '164' THEN '45 - NSW TrainLink'
            WHEN '165' THEN '45 - NSW TrainLink'
            WHEN '166' THEN '45 - NSW TrainLink'
            WHEN '167' THEN '44 - Sydney Trains'
            WHEN '168' THEN '45 - NSW TrainLink'
            WHEN '169' THEN '45 - NSW TrainLink'
            WHEN '170' THEN '45 - NSW TrainLink'
            WHEN '171' THEN '45 - NSW TrainLink'
            WHEN '180' THEN '44 - Sydney Trains'
            WHEN '181' THEN '44 - Sydney Trains'
            WHEN '182' THEN '44 - Sydney Trains'
            WHEN '183' THEN '44 - Sydney Trains'
            WHEN '184' THEN '44 - Sydney Trains'
            WHEN '185' THEN '44 - Sydney Trains'
            WHEN '186' THEN '44 - Sydney Trains'
            WHEN '187' THEN '44 - Sydney Trains'
            WHEN '188' THEN '44 - Sydney Trains'
            WHEN '189' THEN '44 - Sydney Trains'
            WHEN '190' THEN '44 - Sydney Trains'
            WHEN '191' THEN 'Chatswood'    -- Chatswood has conditionals for SMNW
            WHEN '192' THEN '44 - Sydney Trains'
            WHEN '193' THEN '44 - Sydney Trains'
            WHEN '194' THEN '44 - Sydney Trains'
            WHEN '195' THEN '45 - NSW TrainLink'
            WHEN '197' THEN '44 - Sydney Trains'
            WHEN '198' THEN '45 - NSW TrainLink'
            WHEN '199' THEN '45 - NSW TrainLink'
            WHEN '200' THEN '45 - NSW TrainLink'
            WHEN '201' THEN '45 - NSW TrainLink'
            WHEN '202' THEN '44 - Sydney Trains'
            WHEN '203' THEN '44 - Sydney Trains'
            WHEN '204' THEN '45 - NSW TrainLink'
            WHEN '205' THEN '45 - NSW TrainLink'
            WHEN '206' THEN '45 - NSW TrainLink'
            WHEN '208' THEN '45 - NSW TrainLink'
            WHEN '209' THEN '45 - NSW TrainLink'
            WHEN '210' THEN '44 - Sydney Trains'
            WHEN '211' THEN '44 - Sydney Trains'
            WHEN '220' THEN '45 - NSW TrainLink'
            WHEN '221' THEN '44 - Sydney Trains'
            WHEN '222' THEN '45 - NSW TrainLink'
            WHEN '223' THEN '44 - Sydney Trains'
            WHEN '224' THEN '44 - Sydney Trains'
            WHEN '225' THEN '45 - NSW TrainLink'
            WHEN '226' THEN '44 - Sydney Trains'
            WHEN '227' THEN '45 - NSW TrainLink'
            WHEN '228' THEN '44 - Sydney Trains'
            WHEN '229' THEN '45 - NSW TrainLink'
            WHEN '230' THEN '44 - Sydney Trains'
            WHEN '231' THEN '44 - Sydney Trains'
            WHEN '232' THEN '44 - Sydney Trains'
            WHEN '233' THEN '44 - Sydney Trains'
            WHEN '234' THEN '44 - Sydney Trains'
            WHEN '235' THEN 'Epping'    -- Epping has conditionals for SMNW
            WHEN '236' THEN '44 - Sydney Trains'
            WHEN '237' THEN '45 - NSW TrainLink'
            WHEN '239' THEN '45 - NSW TrainLink'
            WHEN '240' THEN '44 - Sydney Trains'
            WHEN '241' THEN '45 - NSW TrainLink'
            WHEN '242' THEN '45 - NSW TrainLink'
            WHEN '243' THEN '44 - Sydney Trains'
            WHEN '249' THEN '45 - NSW TrainLink'
            WHEN '250' THEN '45 - NSW TrainLink'
            WHEN '251' THEN '44 - Sydney Trains'
            WHEN '252' THEN '45 - NSW TrainLink'
            WHEN '253' THEN '45 - NSW TrainLink'
            WHEN '254' THEN '44 - Sydney Trains'
            WHEN '255' THEN '44 - Sydney Trains'
            WHEN '256' THEN '44 - Sydney Trains'
            WHEN '257' THEN '44 - Sydney Trains'
            WHEN '258' THEN '44 - Sydney Trains'
            WHEN '259' THEN '45 - NSW TrainLink'
            WHEN '260' THEN '44 - Sydney Trains'
            WHEN '261' THEN '45 - NSW TrainLink'
            WHEN '262' THEN '45 - NSW TrainLink'
            WHEN '263' THEN '45 - NSW TrainLink'
            WHEN '264' THEN '45 - NSW TrainLink'
            WHEN '265' THEN '44 - Sydney Trains'
            WHEN '266' THEN '45 - NSW TrainLink'
            WHEN '267' THEN '45 - NSW TrainLink'
            WHEN '268' THEN '44 - Sydney Trains'
            WHEN '269' THEN '45 - NSW TrainLink'
            WHEN '270' THEN '44 - Sydney Trains'
            WHEN '271' THEN '44 - Sydney Trains'
            WHEN '272' THEN '44 - Sydney Trains'
            WHEN '274' THEN '44 - Sydney Trains'
            WHEN '275' THEN '45 - NSW TrainLink'
            WHEN '280' THEN '44 - Sydney Trains'
            WHEN '281' THEN '44 - Sydney Trains'
            WHEN '290' THEN '44 - Sydney Trains'
            WHEN '300' THEN '45 - NSW TrainLink'
            WHEN '301' THEN '45 - NSW TrainLink'
            WHEN '302' THEN '45 - NSW TrainLink'
            WHEN '303' THEN '44 - Sydney Trains'
            WHEN '304' THEN '44 - Sydney Trains'
            WHEN '305' THEN '44 - Sydney Trains'
            WHEN '306' THEN '44 - Sydney Trains'
            WHEN '307' THEN '44 - Sydney Trains'
            WHEN '308' THEN '45 - NSW TrainLink'
            WHEN '309' THEN '45 - NSW TrainLink'
            WHEN '320' THEN '44 - Sydney Trains'
            WHEN '321' THEN '45 - NSW TrainLink'
            WHEN '322' THEN '45 - NSW TrainLink'
            WHEN '323' THEN '44 - Sydney Trains'
            WHEN '324' THEN '45 - NSW TrainLink'
            WHEN '325' THEN '44 - Sydney Trains'
            WHEN '326' THEN '44 - Sydney Trains'
            WHEN '328' THEN '44 - Sydney Trains'
            WHEN '330' THEN '45 - NSW TrainLink'
            WHEN '331' THEN '44 - Sydney Trains'
            WHEN '332' THEN '44 - Sydney Trains'
            WHEN '333' THEN '45 - NSW TrainLink'
            WHEN '334' THEN '44 - Sydney Trains'
            WHEN '335' THEN '45 - NSW TrainLink'
            WHEN '336' THEN '45 - NSW TrainLink'
            WHEN '337' THEN '45 - NSW TrainLink'
            WHEN '338' THEN '45 - NSW TrainLink'
            WHEN '339' THEN '45 - NSW TrainLink'
            WHEN '340' THEN '44 - Sydney Trains'
            WHEN '341' THEN '44 - Sydney Trains'
            WHEN '342' THEN '45 - NSW TrainLink'
            WHEN '343' THEN '44 - Sydney Trains'
            WHEN '344' THEN '44 - Sydney Trains'
            WHEN '345' THEN '44 - Sydney Trains'
            WHEN '346' THEN '45 - NSW TrainLink'
            WHEN '347' THEN '45 - NSW TrainLink'
            WHEN '348' THEN '45 - NSW TrainLink'
            WHEN '349' THEN '44 - Sydney Trains'
            WHEN '350' THEN '44 - Sydney Trains'
            WHEN '351' THEN '45 - NSW TrainLink'
            WHEN '352' THEN '44 - Sydney Trains'
            WHEN '353' THEN '44 - Sydney Trains'
            WHEN '354' THEN '45 - NSW TrainLink'
            WHEN '355' THEN '44 - Sydney Trains'
            WHEN '356' THEN '45 - NSW TrainLink'
            WHEN '357' THEN '45 - NSW TrainLink'
            WHEN '358' THEN '44 - Sydney Trains'
            WHEN '359' THEN '44 - Sydney Trains'
            WHEN '360' THEN '44 - Sydney Trains'
            WHEN '361' THEN '44 - Sydney Trains'
            WHEN '362' THEN '45 - NSW TrainLink'
            WHEN '363' THEN '44 - Sydney Trains'
            WHEN '364' THEN '44 - Sydney Trains'
            WHEN '365' THEN '45 - NSW TrainLink'
            WHEN '366' THEN '45 - NSW TrainLink'
            WHEN '370' THEN '44 - Sydney Trains'
            WHEN '372' THEN '44 - Sydney Trains'
            WHEN '373' THEN '45 - NSW TrainLink'
            WHEN '374' THEN '45 - NSW TrainLink'
            WHEN '375' THEN '44 - Sydney Trains'
            WHEN '376' THEN '44 - Sydney Trains'
            WHEN '377' THEN '44 - Sydney Trains'
            WHEN '378' THEN '45 - NSW TrainLink'
            WHEN '380' THEN '45 - NSW TrainLink'
            WHEN '385' THEN '45 - NSW TrainLink'
            WHEN '390' THEN '45 - NSW TrainLink'
            WHEN '391' THEN '44 - Sydney Trains'
            WHEN '392' THEN '45 - NSW TrainLink'
            WHEN '394' THEN '45 - NSW TrainLink'
            WHEN '398' THEN '45 - NSW TrainLink'
            WHEN '399' THEN '45 - NSW TrainLink'
            WHEN '400' THEN '44 - Sydney Trains'
            WHEN '401' THEN '44 - Sydney Trains'
            WHEN '402' THEN '44 - Sydney Trains'
            WHEN '403' THEN '44 - Sydney Trains'
            WHEN '404' THEN '44 - Sydney Trains'
            WHEN '405' THEN '44 - Sydney Trains'
            WHEN '406' THEN '44 - Sydney Trains'
            WHEN '407' THEN '44 - Sydney Trains'
            WHEN '408' THEN '45 - NSW TrainLink'
            WHEN '409' THEN '44 - Sydney Trains'
            WHEN '411' THEN '45 - NSW TrainLink'
            WHEN '412' THEN '45 - NSW TrainLink'
            WHEN '413' THEN '45 - NSW TrainLink'
            WHEN '414' THEN '44 - Sydney Trains'
            WHEN '415' THEN '44 - Sydney Trains'
            WHEN '420' THEN '44 - Sydney Trains'
            WHEN '430' THEN '44 - Sydney Trains'
            WHEN '431' THEN '44 - Sydney Trains'
            WHEN '432' THEN '44 - Sydney Trains'
            WHEN '433' THEN '44 - Sydney Trains'
            WHEN '434' THEN '44 - Sydney Trains'
            WHEN '435' THEN '44 - Sydney Trains'
            WHEN '436' THEN '44 - Sydney Trains'
            WHEN '437' THEN '44 - Sydney Trains'
            WHEN '438' THEN '44 - Sydney Trains'
            WHEN '439' THEN '44 - Sydney Trains'
            WHEN '440' THEN '44 - Sydney Trains'
            WHEN '442' THEN '44 - Sydney Trains'
            WHEN '443' THEN '45 - NSW TrainLink'
            WHEN '449' THEN '44 - Sydney Trains'
            WHEN '450' THEN '45 - NSW TrainLink'
            WHEN '451' THEN '44 - Sydney Trains'
            WHEN '452' THEN '44 - Sydney Trains'
            WHEN '454' THEN '45 - NSW TrainLink'
            WHEN '455' THEN '44 - Sydney Trains'
            WHEN '456' THEN '44 - Sydney Trains'
            WHEN '457' THEN '44 - Sydney Trains'
            WHEN '458' THEN '45 - NSW TrainLink'
            WHEN '459' THEN '45 - NSW TrainLink'
            WHEN '460' THEN '44 - Sydney Trains'
            WHEN '461' THEN '44 - Sydney Trains'
            WHEN '462' THEN '44 - Sydney Trains'
            WHEN '463' THEN '44 - Sydney Trains'
            WHEN '464' THEN '45 - NSW TrainLink'
            WHEN '465' THEN '44 - Sydney Trains'
            WHEN '466' THEN '45 - NSW TrainLink'
            WHEN '467' THEN '45 - NSW TrainLink'
            WHEN '468' THEN '45 - NSW TrainLink'
            WHEN '469' THEN '45 - NSW TrainLink'
            WHEN '470' THEN '45 - NSW TrainLink'
            WHEN '471' THEN '45 - NSW TrainLink'
            WHEN '472' THEN '45 - NSW TrainLink'
            WHEN '473' THEN '44 - Sydney Trains'
            WHEN '474' THEN '44 - Sydney Trains'
            WHEN '475' THEN '45 - NSW TrainLink'
            WHEN '476' THEN '45 - NSW TrainLink'
            WHEN '477' THEN '44 - Sydney Trains'
            WHEN '478' THEN '44 - Sydney Trains'
            WHEN '479' THEN '45 - NSW TrainLink'
            WHEN '481' THEN '45 - NSW TrainLink'
            WHEN '482' THEN '44 - Sydney Trains'
            WHEN '483' THEN '44 - Sydney Trains'
            WHEN '484' THEN '45 - NSW TrainLink'
            WHEN '485' THEN '45 - NSW TrainLink'
            WHEN '486' THEN '45 - NSW TrainLink'
            WHEN '490' THEN '45 - NSW TrainLink'
            WHEN '491' THEN '44 - Sydney Trains'
            WHEN '492' THEN '44 - Sydney Trains'
            WHEN '493' THEN '45 - NSW TrainLink'
            WHEN '499' THEN '45 - NSW TrainLink'
            WHEN '500' THEN '44 - Sydney Trains'
            WHEN '501' THEN '44 - Sydney Trains'
            WHEN '502' THEN '45 - NSW TrainLink'
            WHEN '503' THEN '45 - NSW TrainLink'
            WHEN '504' THEN '44 - Sydney Trains'
            WHEN '505' THEN '45 - NSW TrainLink'
            WHEN '506' THEN '44 - Sydney Trains'
            WHEN '507' THEN '44 - Sydney Trains'
            WHEN '508' THEN '44 - Sydney Trains'
            WHEN '509' THEN '45 - NSW TrainLink'
            WHEN '510' THEN '44 - Sydney Trains'
            WHEN '511' THEN '44 - Sydney Trains'
            WHEN '512' THEN '44 - Sydney Trains'
            WHEN '513' THEN '44 - Sydney Trains'
            WHEN '514' THEN '44 - Sydney Trains'
            WHEN '515' THEN '44 - Sydney Trains'
            WHEN '516' THEN '45 - NSW TrainLink'
            WHEN '517' THEN '45 - NSW TrainLink'
            WHEN '518' THEN '45 - NSW TrainLink'
            WHEN '519' THEN '45 - NSW TrainLink'
            WHEN '520' THEN '44 - Sydney Trains'
            WHEN '521' THEN '45 - NSW TrainLink'
            WHEN '522' THEN '45 - NSW TrainLink'
            WHEN '523' THEN '45 - NSW TrainLink'
            WHEN '524' THEN '45 - NSW TrainLink'
            WHEN '525' THEN '45 - NSW TrainLink'
            WHEN '526' THEN '44 - Sydney Trains'
            WHEN '527' THEN '45 - NSW TrainLink'
            WHEN '528' THEN '44 - Sydney Trains'
            WHEN '529' THEN '45 - NSW TrainLink'
            WHEN '540' THEN '44 - Sydney Trains'
            WHEN '544' THEN '44 - Sydney Trains'
            WHEN '545' THEN '45 - NSW TrainLink'
            WHEN '546' THEN '45 - NSW TrainLink'
            WHEN '547' THEN '45 - NSW TrainLink'
            WHEN '548' THEN '45 - NSW TrainLink'
            WHEN '549' THEN '45 - NSW TrainLink'
            WHEN '550' THEN '45 - NSW TrainLink'
            WHEN '551' THEN '45 - NSW TrainLink'
            WHEN '552' THEN '45 - NSW TrainLink'
            WHEN '553' THEN '45 - NSW TrainLink'
            WHEN '560' THEN '44 - Sydney Trains'
            WHEN '561' THEN '44 - Sydney Trains'
            WHEN '562' THEN '44 - Sydney Trains'
            WHEN '574' THEN '45 - NSW TrainLink'
            WHEN '581' THEN '37 - Metro Trains Sydney'
            WHEN '582' THEN '37 - Metro Trains Sydney'
            WHEN '583' THEN '37 - Metro Trains Sydney'
            WHEN '584' THEN '37 - Metro Trains Sydney'
            WHEN '585' THEN '37 - Metro Trains Sydney'
            WHEN '586' THEN '37 - Metro Trains Sydney'
            WHEN '587' THEN '37 - Metro Trains Sydney'
            WHEN '588' THEN '37 - Metro Trains Sydney'
            WHEN '625' THEN '44 - Sydney Trains'
            WHEN '626' THEN '44 - Sydney Trains'
            WHEN '801' THEN '46 - Sydney Light Rail'
            WHEN '802' THEN '46 - Sydney Light Rail'
            WHEN '803' THEN '46 - Sydney Light Rail'
            WHEN '804' THEN '46 - Sydney Light Rail'
            WHEN '805' THEN '46 - Sydney Light Rail'
            WHEN '806' THEN '46 - Sydney Light Rail'
            WHEN '807' THEN '46 - Sydney Light Rail'
            WHEN '808' THEN '46 - Sydney Light Rail'
            WHEN '809' THEN '46 - Sydney Light Rail'
            WHEN '810' THEN '46 - Sydney Light Rail'
            WHEN '811' THEN '46 - Sydney Light Rail'
            WHEN '812' THEN '46 - Sydney Light Rail'
            WHEN '813' THEN '46 - Sydney Light Rail'
            WHEN '814' THEN '46 - Sydney Light Rail'
            WHEN '815' THEN '46 - Sydney Light Rail'
            WHEN '816' THEN '46 - Sydney Light Rail'
            WHEN '817' THEN '46 - Sydney Light Rail'
            WHEN '818' THEN '46 - Sydney Light Rail'
            WHEN '819' THEN '46 - Sydney Light Rail'
            WHEN '820' THEN '46 - Sydney Light Rail'
            WHEN '821' THEN '46 - Sydney Light Rail'
            WHEN '822' THEN '46 - Sydney Light Rail'
            WHEN '823' THEN '46 - Sydney Light Rail'
            WHEN '853' THEN '38 - Newcastle Transport'
            WHEN '854' THEN '38 - Newcastle Transport'
            WHEN '855' THEN '38 - Newcastle Transport'
            WHEN '856' THEN '38 - Newcastle Transport'
            WHEN '857' THEN '38 - Newcastle Transport'
            WHEN '858' THEN '38 - Newcastle Transport'
            WHEN '935' THEN '1 - Sydney Ferries'
            WHEN '936' THEN '1 - Sydney Ferries'
            WHEN '937' THEN '1 - Sydney Ferries'
            WHEN '938' THEN '1 - Sydney Ferries'
            WHEN '939' THEN '1 - Sydney Ferries'
            WHEN '943' THEN '1 - Sydney Ferries'
            WHEN '944' THEN '1 - Sydney Ferries'
            WHEN '945' THEN '1 - Sydney Ferries'
            WHEN '946' THEN '1 - Sydney Ferries'
            WHEN '947' THEN '1 - Sydney Ferries'
            WHEN '948' THEN '1 - Sydney Ferries'
            WHEN '950' THEN '1 - Sydney Ferries'
            WHEN '952' THEN '1 - Sydney Ferries'
            WHEN '953' THEN '1 - Sydney Ferries'
            WHEN '954' THEN '1 - Sydney Ferries'
            WHEN '955' THEN '1 - Sydney Ferries'
            WHEN '956' THEN '1 - Sydney Ferries'
            WHEN '957' THEN '1 - Sydney Ferries'
            WHEN '958' THEN '1 - Sydney Ferries'
            WHEN '959' THEN '1 - Sydney Ferries'
            WHEN '960' THEN '1 - Sydney Ferries'
            WHEN '961' THEN '1 - Sydney Ferries'
            WHEN '962' THEN '1 - Sydney Ferries'
            WHEN '963' THEN '1 - Sydney Ferries'
            WHEN '964' THEN '1 - Sydney Ferries'
            WHEN '965' THEN '1 - Sydney Ferries'
            WHEN '968' THEN '1 - Sydney Ferries'
            WHEN '969' THEN '1 - Sydney Ferries'
            WHEN '970' THEN '1 - Sydney Ferries'
            WHEN '971' THEN '1 - Sydney Ferries'
            WHEN '972' THEN '1 - Sydney Ferries'
            WHEN '973' THEN '1 - Sydney Ferries'
            WHEN '974' THEN '1 - Sydney Ferries'
            WHEN '977' THEN '1 - Sydney Ferries'
            WHEN '979' THEN '1 - Sydney Ferries'
            WHEN '980' THEN '1 - Sydney Ferries'
            WHEN '981' THEN '1 - Sydney Ferries'
            WHEN '982' THEN '1 - Sydney Ferries'
            WHEN '983' THEN '1 - Sydney Ferries'
            WHEN '985' THEN '1 - Sydney Ferries'
            WHEN '9999' THEN '1 - Sydney Ferries'
        ELSE '404 - Not Found' END as Entry_ETS_Operator,
        exit_transaction_dtm,
        exit_stop_id,
        CASE exit_stop_id
            WHEN '11' THEN '1 - Sydney Ferries'
            WHEN '100' THEN '44 - Sydney Trains'
            WHEN '101' THEN '44 - Sydney Trains'
            WHEN '102' THEN '44 - Sydney Trains'
            WHEN '103' THEN '44 - Sydney Trains'
            WHEN '104' THEN '44 - Sydney Trains'
            WHEN '105' THEN '44 - Sydney Trains'
            WHEN '106' THEN '44 - Sydney Trains'
            WHEN '107' THEN '44 - Sydney Trains'
            WHEN '108' THEN '44 - Sydney Trains'
            WHEN '109' THEN '44 - Sydney Trains'
            WHEN '120' THEN '45 - NSW TrainLink'
            WHEN '121' THEN '45 - NSW TrainLink'
            WHEN '122' THEN '44 - Sydney Trains'
            WHEN '123' THEN '44 - Sydney Trains'
            WHEN '124' THEN '44 - Sydney Trains'
            WHEN '125' THEN '44 - Sydney Trains'
            WHEN '127' THEN '44 - Sydney Trains'
            WHEN '128' THEN '44 - Sydney Trains'
            WHEN '129' THEN '45 - NSW TrainLink'
            WHEN '130' THEN '45 - NSW TrainLink'
            WHEN '131' THEN '45 - NSW TrainLink'
            WHEN '140' THEN '45 - NSW TrainLink'
            WHEN '141' THEN '44 - Sydney Trains'
            WHEN '142' THEN '44 - Sydney Trains'
            WHEN '144' THEN '44 - Sydney Trains'
            WHEN '145' THEN '45 - NSW TrainLink'
            WHEN '146' THEN '44 - Sydney Trains'
            WHEN '147' THEN '45 - NSW TrainLink'
            WHEN '148' THEN '45 - NSW TrainLink'
            WHEN '149' THEN '44 - Sydney Trains'
            WHEN '150' THEN '44 - Sydney Trains'
            WHEN '151' THEN '45 - NSW TrainLink'
            WHEN '152' THEN '44 - Sydney Trains'
            WHEN '153' THEN '44 - Sydney Trains'
            WHEN '154' THEN '44 - Sydney Trains'
            WHEN '155' THEN '44 - Sydney Trains'
            WHEN '157' THEN '45 - NSW TrainLink'
            WHEN '158' THEN '44 - Sydney Trains'
            WHEN '159' THEN '45 - NSW TrainLink'
            WHEN '160' THEN '45 - NSW TrainLink'
            WHEN '161' THEN '45 - NSW TrainLink'
            WHEN '162' THEN '45 - NSW TrainLink'
            WHEN '163' THEN '45 - NSW TrainLink'
            WHEN '164' THEN '45 - NSW TrainLink'
            WHEN '165' THEN '45 - NSW TrainLink'
            WHEN '166' THEN '45 - NSW TrainLink'
            WHEN '167' THEN '44 - Sydney Trains'
            WHEN '168' THEN '45 - NSW TrainLink'
            WHEN '169' THEN '45 - NSW TrainLink'
            WHEN '170' THEN '45 - NSW TrainLink'
            WHEN '171' THEN '45 - NSW TrainLink'
            WHEN '180' THEN '44 - Sydney Trains'
            WHEN '181' THEN '44 - Sydney Trains'
            WHEN '182' THEN '44 - Sydney Trains'
            WHEN '183' THEN '44 - Sydney Trains'
            WHEN '184' THEN '44 - Sydney Trains'
            WHEN '185' THEN '44 - Sydney Trains'
            WHEN '186' THEN '44 - Sydney Trains'
            WHEN '187' THEN '44 - Sydney Trains'
            WHEN '188' THEN '44 - Sydney Trains'
            WHEN '189' THEN '44 - Sydney Trains'
            WHEN '190' THEN '44 - Sydney Trains'
            WHEN '191' THEN 'Chatswood'    -- Chatswood has conditionals for SMNW
            WHEN '192' THEN '44 - Sydney Trains'
            WHEN '193' THEN '44 - Sydney Trains'
            WHEN '194' THEN '44 - Sydney Trains'
            WHEN '195' THEN '45 - NSW TrainLink'
            WHEN '197' THEN '44 - Sydney Trains'
            WHEN '198' THEN '45 - NSW TrainLink'
            WHEN '199' THEN '45 - NSW TrainLink'
            WHEN '200' THEN '45 - NSW TrainLink'
            WHEN '201' THEN '45 - NSW TrainLink'
            WHEN '202' THEN '44 - Sydney Trains'
            WHEN '203' THEN '44 - Sydney Trains'
            WHEN '204' THEN '45 - NSW TrainLink'
            WHEN '205' THEN '45 - NSW TrainLink'
            WHEN '206' THEN '45 - NSW TrainLink'
            WHEN '208' THEN '45 - NSW TrainLink'
            WHEN '209' THEN '45 - NSW TrainLink'
            WHEN '210' THEN '44 - Sydney Trains'
            WHEN '211' THEN '44 - Sydney Trains'
            WHEN '220' THEN '45 - NSW TrainLink'
            WHEN '221' THEN '44 - Sydney Trains'
            WHEN '222' THEN '45 - NSW TrainLink'
            WHEN '223' THEN '44 - Sydney Trains'
            WHEN '224' THEN '44 - Sydney Trains'
            WHEN '225' THEN '45 - NSW TrainLink'
            WHEN '226' THEN '44 - Sydney Trains'
            WHEN '227' THEN '45 - NSW TrainLink'
            WHEN '228' THEN '44 - Sydney Trains'
            WHEN '229' THEN '45 - NSW TrainLink'
            WHEN '230' THEN '44 - Sydney Trains'
            WHEN '231' THEN '44 - Sydney Trains'
            WHEN '232' THEN '44 - Sydney Trains'
            WHEN '233' THEN '44 - Sydney Trains'
            WHEN '234' THEN '44 - Sydney Trains'
            WHEN '235' THEN 'Epping'    -- Epping has conditionals for SMNW
            WHEN '236' THEN '44 - Sydney Trains'
            WHEN '237' THEN '45 - NSW TrainLink'
            WHEN '239' THEN '45 - NSW TrainLink'
            WHEN '240' THEN '44 - Sydney Trains'
            WHEN '241' THEN '45 - NSW TrainLink'
            WHEN '242' THEN '45 - NSW TrainLink'
            WHEN '243' THEN '44 - Sydney Trains'
            WHEN '249' THEN '45 - NSW TrainLink'
            WHEN '250' THEN '45 - NSW TrainLink'
            WHEN '251' THEN '44 - Sydney Trains'
            WHEN '252' THEN '45 - NSW TrainLink'
            WHEN '253' THEN '45 - NSW TrainLink'
            WHEN '254' THEN '44 - Sydney Trains'
            WHEN '255' THEN '44 - Sydney Trains'
            WHEN '256' THEN '44 - Sydney Trains'
            WHEN '257' THEN '44 - Sydney Trains'
            WHEN '258' THEN '44 - Sydney Trains'
            WHEN '259' THEN '45 - NSW TrainLink'
            WHEN '260' THEN '44 - Sydney Trains'
            WHEN '261' THEN '45 - NSW TrainLink'
            WHEN '262' THEN '45 - NSW TrainLink'
            WHEN '263' THEN '45 - NSW TrainLink'
            WHEN '264' THEN '45 - NSW TrainLink'
            WHEN '265' THEN '44 - Sydney Trains'
            WHEN '266' THEN '45 - NSW TrainLink'
            WHEN '267' THEN '45 - NSW TrainLink'
            WHEN '268' THEN '44 - Sydney Trains'
            WHEN '269' THEN '45 - NSW TrainLink'
            WHEN '270' THEN '44 - Sydney Trains'
            WHEN '271' THEN '44 - Sydney Trains'
            WHEN '272' THEN '44 - Sydney Trains'
            WHEN '274' THEN '44 - Sydney Trains'
            WHEN '275' THEN '45 - NSW TrainLink'
            WHEN '280' THEN '44 - Sydney Trains'
            WHEN '281' THEN '44 - Sydney Trains'
            WHEN '290' THEN '44 - Sydney Trains'
            WHEN '300' THEN '45 - NSW TrainLink'
            WHEN '301' THEN '45 - NSW TrainLink'
            WHEN '302' THEN '45 - NSW TrainLink'
            WHEN '303' THEN '44 - Sydney Trains'
            WHEN '304' THEN '44 - Sydney Trains'
            WHEN '305' THEN '44 - Sydney Trains'
            WHEN '306' THEN '44 - Sydney Trains'
            WHEN '307' THEN '44 - Sydney Trains'
            WHEN '308' THEN '45 - NSW TrainLink'
            WHEN '309' THEN '45 - NSW TrainLink'
            WHEN '320' THEN '44 - Sydney Trains'
            WHEN '321' THEN '45 - NSW TrainLink'
            WHEN '322' THEN '45 - NSW TrainLink'
            WHEN '323' THEN '44 - Sydney Trains'
            WHEN '324' THEN '45 - NSW TrainLink'
            WHEN '325' THEN '44 - Sydney Trains'
            WHEN '326' THEN '44 - Sydney Trains'
            WHEN '328' THEN '44 - Sydney Trains'
            WHEN '330' THEN '45 - NSW TrainLink'
            WHEN '331' THEN '44 - Sydney Trains'
            WHEN '332' THEN '44 - Sydney Trains'
            WHEN '333' THEN '45 - NSW TrainLink'
            WHEN '334' THEN '44 - Sydney Trains'
            WHEN '335' THEN '45 - NSW TrainLink'
            WHEN '336' THEN '45 - NSW TrainLink'
            WHEN '337' THEN '45 - NSW TrainLink'
            WHEN '338' THEN '45 - NSW TrainLink'
            WHEN '339' THEN '45 - NSW TrainLink'
            WHEN '340' THEN '44 - Sydney Trains'
            WHEN '341' THEN '44 - Sydney Trains'
            WHEN '342' THEN '45 - NSW TrainLink'
            WHEN '343' THEN '44 - Sydney Trains'
            WHEN '344' THEN '44 - Sydney Trains'
            WHEN '345' THEN '44 - Sydney Trains'
            WHEN '346' THEN '45 - NSW TrainLink'
            WHEN '347' THEN '45 - NSW TrainLink'
            WHEN '348' THEN '45 - NSW TrainLink'
            WHEN '349' THEN '44 - Sydney Trains'
            WHEN '350' THEN '44 - Sydney Trains'
            WHEN '351' THEN '45 - NSW TrainLink'
            WHEN '352' THEN '44 - Sydney Trains'
            WHEN '353' THEN '44 - Sydney Trains'
            WHEN '354' THEN '45 - NSW TrainLink'
            WHEN '355' THEN '44 - Sydney Trains'
            WHEN '356' THEN '45 - NSW TrainLink'
            WHEN '357' THEN '45 - NSW TrainLink'
            WHEN '358' THEN '44 - Sydney Trains'
            WHEN '359' THEN '44 - Sydney Trains'
            WHEN '360' THEN '44 - Sydney Trains'
            WHEN '361' THEN '44 - Sydney Trains'
            WHEN '362' THEN '45 - NSW TrainLink'
            WHEN '363' THEN '44 - Sydney Trains'
            WHEN '364' THEN '44 - Sydney Trains'
            WHEN '365' THEN '45 - NSW TrainLink'
            WHEN '366' THEN '45 - NSW TrainLink'
            WHEN '370' THEN '44 - Sydney Trains'
            WHEN '372' THEN '44 - Sydney Trains'
            WHEN '373' THEN '45 - NSW TrainLink'
            WHEN '374' THEN '45 - NSW TrainLink'
            WHEN '375' THEN '44 - Sydney Trains'
            WHEN '376' THEN '44 - Sydney Trains'
            WHEN '377' THEN '44 - Sydney Trains'
            WHEN '378' THEN '45 - NSW TrainLink'
            WHEN '380' THEN '45 - NSW TrainLink'
            WHEN '385' THEN '45 - NSW TrainLink'
            WHEN '390' THEN '45 - NSW TrainLink'
            WHEN '391' THEN '44 - Sydney Trains'
            WHEN '392' THEN '45 - NSW TrainLink'
            WHEN '394' THEN '45 - NSW TrainLink'
            WHEN '398' THEN '45 - NSW TrainLink'
            WHEN '399' THEN '45 - NSW TrainLink'
            WHEN '400' THEN '44 - Sydney Trains'
            WHEN '401' THEN '44 - Sydney Trains'
            WHEN '402' THEN '44 - Sydney Trains'
            WHEN '403' THEN '44 - Sydney Trains'
            WHEN '404' THEN '44 - Sydney Trains'
            WHEN '405' THEN '44 - Sydney Trains'
            WHEN '406' THEN '44 - Sydney Trains'
            WHEN '407' THEN '44 - Sydney Trains'
            WHEN '408' THEN '45 - NSW TrainLink'
            WHEN '409' THEN '44 - Sydney Trains'
            WHEN '411' THEN '45 - NSW TrainLink'
            WHEN '412' THEN '45 - NSW TrainLink'
            WHEN '413' THEN '45 - NSW TrainLink'
            WHEN '414' THEN '44 - Sydney Trains'
            WHEN '415' THEN '44 - Sydney Trains'
            WHEN '420' THEN '44 - Sydney Trains'
            WHEN '430' THEN '44 - Sydney Trains'
            WHEN '431' THEN '44 - Sydney Trains'
            WHEN '432' THEN '44 - Sydney Trains'
            WHEN '433' THEN '44 - Sydney Trains'
            WHEN '434' THEN '44 - Sydney Trains'
            WHEN '435' THEN '44 - Sydney Trains'
            WHEN '436' THEN '44 - Sydney Trains'
            WHEN '437' THEN '44 - Sydney Trains'
            WHEN '438' THEN '44 - Sydney Trains'
            WHEN '439' THEN '44 - Sydney Trains'
            WHEN '440' THEN '44 - Sydney Trains'
            WHEN '442' THEN '44 - Sydney Trains'
            WHEN '443' THEN '45 - NSW TrainLink'
            WHEN '449' THEN '44 - Sydney Trains'
            WHEN '450' THEN '45 - NSW TrainLink'
            WHEN '451' THEN '44 - Sydney Trains'
            WHEN '452' THEN '44 - Sydney Trains'
            WHEN '454' THEN '45 - NSW TrainLink'
            WHEN '455' THEN '44 - Sydney Trains'
            WHEN '456' THEN '44 - Sydney Trains'
            WHEN '457' THEN '44 - Sydney Trains'
            WHEN '458' THEN '45 - NSW TrainLink'
            WHEN '459' THEN '45 - NSW TrainLink'
            WHEN '460' THEN '44 - Sydney Trains'
            WHEN '461' THEN '44 - Sydney Trains'
            WHEN '462' THEN '44 - Sydney Trains'
            WHEN '463' THEN '44 - Sydney Trains'
            WHEN '464' THEN '45 - NSW TrainLink'
            WHEN '465' THEN '44 - Sydney Trains'
            WHEN '466' THEN '45 - NSW TrainLink'
            WHEN '467' THEN '45 - NSW TrainLink'
            WHEN '468' THEN '45 - NSW TrainLink'
            WHEN '469' THEN '45 - NSW TrainLink'
            WHEN '470' THEN '45 - NSW TrainLink'
            WHEN '471' THEN '45 - NSW TrainLink'
            WHEN '472' THEN '45 - NSW TrainLink'
            WHEN '473' THEN '44 - Sydney Trains'
            WHEN '474' THEN '44 - Sydney Trains'
            WHEN '475' THEN '45 - NSW TrainLink'
            WHEN '476' THEN '45 - NSW TrainLink'
            WHEN '477' THEN '44 - Sydney Trains'
            WHEN '478' THEN '44 - Sydney Trains'
            WHEN '479' THEN '45 - NSW TrainLink'
            WHEN '481' THEN '45 - NSW TrainLink'
            WHEN '482' THEN '44 - Sydney Trains'
            WHEN '483' THEN '44 - Sydney Trains'
            WHEN '484' THEN '45 - NSW TrainLink'
            WHEN '485' THEN '45 - NSW TrainLink'
            WHEN '486' THEN '45 - NSW TrainLink'
            WHEN '490' THEN '45 - NSW TrainLink'
            WHEN '491' THEN '44 - Sydney Trains'
            WHEN '492' THEN '44 - Sydney Trains'
            WHEN '493' THEN '45 - NSW TrainLink'
            WHEN '499' THEN '45 - NSW TrainLink'
            WHEN '500' THEN '44 - Sydney Trains'
            WHEN '501' THEN '44 - Sydney Trains'
            WHEN '502' THEN '45 - NSW TrainLink'
            WHEN '503' THEN '45 - NSW TrainLink'
            WHEN '504' THEN '44 - Sydney Trains'
            WHEN '505' THEN '45 - NSW TrainLink'
            WHEN '506' THEN '44 - Sydney Trains'
            WHEN '507' THEN '44 - Sydney Trains'
            WHEN '508' THEN '44 - Sydney Trains'
            WHEN '509' THEN '45 - NSW TrainLink'
            WHEN '510' THEN '44 - Sydney Trains'
            WHEN '511' THEN '44 - Sydney Trains'
            WHEN '512' THEN '44 - Sydney Trains'
            WHEN '513' THEN '44 - Sydney Trains'
            WHEN '514' THEN '44 - Sydney Trains'
            WHEN '515' THEN '44 - Sydney Trains'
            WHEN '516' THEN '45 - NSW TrainLink'
            WHEN '517' THEN '45 - NSW TrainLink'
            WHEN '518' THEN '45 - NSW TrainLink'
            WHEN '519' THEN '45 - NSW TrainLink'
            WHEN '520' THEN '44 - Sydney Trains'
            WHEN '521' THEN '45 - NSW TrainLink'
            WHEN '522' THEN '45 - NSW TrainLink'
            WHEN '523' THEN '45 - NSW TrainLink'
            WHEN '524' THEN '45 - NSW TrainLink'
            WHEN '525' THEN '45 - NSW TrainLink'
            WHEN '526' THEN '44 - Sydney Trains'
            WHEN '527' THEN '45 - NSW TrainLink'
            WHEN '528' THEN '44 - Sydney Trains'
            WHEN '529' THEN '45 - NSW TrainLink'
            WHEN '540' THEN '44 - Sydney Trains'
            WHEN '544' THEN '44 - Sydney Trains'
            WHEN '545' THEN '45 - NSW TrainLink'
            WHEN '546' THEN '45 - NSW TrainLink'
            WHEN '547' THEN '45 - NSW TrainLink'
            WHEN '548' THEN '45 - NSW TrainLink'
            WHEN '549' THEN '45 - NSW TrainLink'
            WHEN '550' THEN '45 - NSW TrainLink'
            WHEN '551' THEN '45 - NSW TrainLink'
            WHEN '552' THEN '45 - NSW TrainLink'
            WHEN '553' THEN '45 - NSW TrainLink'
            WHEN '560' THEN '44 - Sydney Trains'
            WHEN '561' THEN '44 - Sydney Trains'
            WHEN '562' THEN '44 - Sydney Trains'
            WHEN '574' THEN '45 - NSW TrainLink'
            WHEN '581' THEN '37 - Metro Trains Sydney'
            WHEN '582' THEN '37 - Metro Trains Sydney'
            WHEN '583' THEN '37 - Metro Trains Sydney'
            WHEN '584' THEN '37 - Metro Trains Sydney'
            WHEN '585' THEN '37 - Metro Trains Sydney'
            WHEN '586' THEN '37 - Metro Trains Sydney'
            WHEN '587' THEN '37 - Metro Trains Sydney'
            WHEN '588' THEN '37 - Metro Trains Sydney'
            WHEN '625' THEN '44 - Sydney Trains'
            WHEN '626' THEN '44 - Sydney Trains'
            WHEN '801' THEN '46 - Sydney Light Rail'
            WHEN '802' THEN '46 - Sydney Light Rail'
            WHEN '803' THEN '46 - Sydney Light Rail'
            WHEN '804' THEN '46 - Sydney Light Rail'
            WHEN '805' THEN '46 - Sydney Light Rail'
            WHEN '806' THEN '46 - Sydney Light Rail'
            WHEN '807' THEN '46 - Sydney Light Rail'
            WHEN '808' THEN '46 - Sydney Light Rail'
            WHEN '809' THEN '46 - Sydney Light Rail'
            WHEN '810' THEN '46 - Sydney Light Rail'
            WHEN '811' THEN '46 - Sydney Light Rail'
            WHEN '812' THEN '46 - Sydney Light Rail'
            WHEN '813' THEN '46 - Sydney Light Rail'
            WHEN '814' THEN '46 - Sydney Light Rail'
            WHEN '815' THEN '46 - Sydney Light Rail'
            WHEN '816' THEN '46 - Sydney Light Rail'
            WHEN '817' THEN '46 - Sydney Light Rail'
            WHEN '818' THEN '46 - Sydney Light Rail'
            WHEN '819' THEN '46 - Sydney Light Rail'
            WHEN '820' THEN '46 - Sydney Light Rail'
            WHEN '821' THEN '46 - Sydney Light Rail'
            WHEN '822' THEN '46 - Sydney Light Rail'
            WHEN '823' THEN '46 - Sydney Light Rail'
            WHEN '853' THEN '38 - Newcastle Transport'
            WHEN '854' THEN '38 - Newcastle Transport'
            WHEN '855' THEN '38 - Newcastle Transport'
            WHEN '856' THEN '38 - Newcastle Transport'
            WHEN '857' THEN '38 - Newcastle Transport'
            WHEN '858' THEN '38 - Newcastle Transport'
            WHEN '935' THEN '1 - Sydney Ferries'
            WHEN '936' THEN '1 - Sydney Ferries'
            WHEN '937' THEN '1 - Sydney Ferries'
            WHEN '938' THEN '1 - Sydney Ferries'
            WHEN '939' THEN '1 - Sydney Ferries'
            WHEN '943' THEN '1 - Sydney Ferries'
            WHEN '944' THEN '1 - Sydney Ferries'
            WHEN '945' THEN '1 - Sydney Ferries'
            WHEN '946' THEN '1 - Sydney Ferries'
            WHEN '947' THEN '1 - Sydney Ferries'
            WHEN '948' THEN '1 - Sydney Ferries'
            WHEN '950' THEN '1 - Sydney Ferries'
            WHEN '952' THEN '1 - Sydney Ferries'
            WHEN '953' THEN '1 - Sydney Ferries'
            WHEN '954' THEN '1 - Sydney Ferries'
            WHEN '955' THEN '1 - Sydney Ferries'
            WHEN '956' THEN '1 - Sydney Ferries'
            WHEN '957' THEN '1 - Sydney Ferries'
            WHEN '958' THEN '1 - Sydney Ferries'
            WHEN '959' THEN '1 - Sydney Ferries'
            WHEN '960' THEN '1 - Sydney Ferries'
            WHEN '961' THEN '1 - Sydney Ferries'
            WHEN '962' THEN '1 - Sydney Ferries'
            WHEN '963' THEN '1 - Sydney Ferries'
            WHEN '964' THEN '1 - Sydney Ferries'
            WHEN '965' THEN '1 - Sydney Ferries'
            WHEN '968' THEN '1 - Sydney Ferries'
            WHEN '969' THEN '1 - Sydney Ferries'
            WHEN '970' THEN '1 - Sydney Ferries'
            WHEN '971' THEN '1 - Sydney Ferries'
            WHEN '972' THEN '1 - Sydney Ferries'
            WHEN '973' THEN '1 - Sydney Ferries'
            WHEN '974' THEN '1 - Sydney Ferries'
            WHEN '977' THEN '1 - Sydney Ferries'
            WHEN '979' THEN '1 - Sydney Ferries'
            WHEN '980' THEN '1 - Sydney Ferries'
            WHEN '981' THEN '1 - Sydney Ferries'
            WHEN '982' THEN '1 - Sydney Ferries'
            WHEN '983' THEN '1 - Sydney Ferries'
            WHEN '985' THEN '1 - Sydney Ferries'
            WHEN '9999' THEN '1 - Sydney Ferries'
        ELSE '404 - Not Found' END as Exit_ETS_Operator,
        calculated_fare,
        calculated_fee,
        fare_due,
        paid_amt,
        cap_amt,
        capping_checked_flag,
        default_fare_flag 
    from abp_main.trip
    where 
        entry_transaction_dtm +11/24 >= (SELECT * FROM StartDate) +4/24 -0 --adjust data set left barrier here
        AND entry_transaction_dtm +11/24 <= sysdate
        AND void_type is null
),
getRRN as (
        select
            je.trip_id,
            bp.PG_RETRIEVAL_REF_NBR
        from abp_main.bankcard_payment bp
        left join abp_main.journal_entry je
        on bp.bankcard_payment_id = je.bankcard_payment_id 
        where je.transaction_dtm +11/24 >= (SELECT * FROM StartDate) -0 -- adjust data set left barrier here
            AND je.transaction_dtm +11/24 <= sysdate
            and je.journal_entry_type_id = 109
        order by bp.updated_dtm desc
),
weekly_total as (
    SELECT 
        trip_id,
        (SELECT * FROM StartDate)+4/24 StartDate,
        trunc(sysdate,'DD') + 1 -0 - (select * from dow)+4/24 -1/86400 EndDate, -- adjust weekly barrier here
        data.entry_transaction_dtm +11/24 as day,        
        token_id, 
        transit_account_id,
        -- Apply apportionment logic
        (CASE WHEN Entry_ETS_Operator = 'Epping' OR Entry_ETS_Operator = 'Chatswood' THEN
                (CASE WHEN Exit_ETS_Operator = '44 - Sydney Trains' THEN '44 - Sydney Trains'
                    WHEN Exit_ETS_Operator = '37 - Metro Trains Sydney' THEN '37 - Metro Trains Sydney'
                    WHEN Exit_ETS_Operator = '45 - NSW TrainLink' THEN '45 - NSW TrainLink'
                    WHEN Exit_ETS_Operator = 'Epping' OR Exit_ETS_Operator = 'Chatswood' THEN
                        (CASE WHEN Entry_ETS_Operator <> Exit_ETS_Operator THEN '37 - Metro Trains Sydney'
                        ELSE '44 - Sydney Trains' -- Default Fare logic
                        END)
                    ELSE 'OPERATOR NOT FOUND'
                END)
            WHEN Entry_ETS_Operator = '37 - Metro Trains Sydney' THEN '37 - Metro Trains Sydney'
            WHEN Entry_ETS_Operator = '45 - NSW TrainLink' THEN '45 - NSW TrainLink'
            WHEN Entry_ETS_Operator = '44 - Sydney Trains' THEN
                (CASE WHEN Exit_ETS_Operator = '45 - NSW TrainLink' THEN '45 - NSW TrainLink'
                ELSE '44 - Sydney Trains'
                END)  
            ELSE Entry_ETS_Operator
        END)
        as Apportioned_ETS_Operator,
        (fare_due-calculated_fee) as fare_due
    FROM data
    where data.entry_transaction_dtm +11/24 < trunc(sysdate,'DD') + 1 -0 - (select * from dow) +4/24 -- adjust weekly barrier here
    and fare_due != 0
),
daily_total as (
    SELECT 
        trip_id,
        data.entry_transaction_dtm +11/24 as day,
        token_id, 
        transit_account_id,
        -- Apply apportionment logic (same as in weekly_total)
        (CASE WHEN Entry_ETS_Operator = 'Epping' OR Entry_ETS_Operator = 'Chatswood' THEN
                (CASE WHEN Exit_ETS_Operator = '44 - Sydney Trains' THEN '44 - Sydney Trains'
                    WHEN Exit_ETS_Operator = '37 - Metro Trains Sydney' THEN '37 - Metro Trains Sydney'
                    WHEN Exit_ETS_Operator = '45 - NSW TrainLink' THEN '45 - NSW TrainLink'
                    WHEN Exit_ETS_Operator = 'Epping' OR Exit_ETS_Operator = 'Chatswood' THEN
                        (CASE WHEN Entry_ETS_Operator <> Exit_ETS_Operator THEN '37 - Metro Trains Sydney'
                        ELSE '44 - Sydney Trains' -- Default Fare logic
                        END)
                    ELSE 'OPERATOR NOT FOUND'
                END)
            WHEN Entry_ETS_Operator = '37 - Metro Trains Sydney' THEN '37 - Metro Trains Sydney'
            WHEN Entry_ETS_Operator = '45 - NSW TrainLink' THEN '45 - NSW TrainLink'
            WHEN Entry_ETS_Operator = '44 - Sydney Trains' THEN
                (CASE WHEN Exit_ETS_Operator = '45 - NSW TrainLink' THEN '45 - NSW TrainLink'
                ELSE '44 - Sydney Trains'
                END)  
            ELSE Entry_ETS_Operator
        END)
        as Apportioned_ETS_Operator,
        (fare_due-calculated_fee) As Fare_Due
    FROM data
    where fare_due != 0
), 
weekly_cumul as (
    select 
        trip_id,
        StartDate,
        endDate,
        day,
        token_id,
        transit_account_id,
        apportioned_ets_operator,
        fare_due, 
        sum(fare_due) over (partition by token_id order by day, token_id) running_weekly_fare,
        sum(fare_due) over (partition by token_id) total_weekly_fare
    from weekly_total
    order by token_id, day desc
),
daily_cumul as (
    select 
        trip_id,
        day,
        to_char(day-(4/24),'DAY', 'NLS_DATE_LANGUAGE=''numeric date language''') as business_day_of_the_week,
        token_id,
        transit_account_id,
        apportioned_ets_operator,
        fare_due,
        sum(fare_due) over (partition by trunc(day-4/24,'dd'), token_id order by day, token_id) running_daily_fare,
        sum(fare_due) over (partition by trunc(day-4/24,'dd'), token_id) total_daily_fare
    from daily_total 
),
daily_report_detailed as (
    -- if capping value changes, change all hardcoded values.
    -- current daily cap is $16.10
    -- current sunday cap is $2.80
    select 
        dc.*,
        (case 
            when business_day_of_the_week = 7 then
                (case
                    when running_daily_fare-280 >= fare_due then fare_due
                    when running_daily_fare-280 < 0 then 0
                    else running_daily_fare-280
                end)
            else 
                (case
                    when running_daily_fare-1610 >= fare_due then fare_due
                    when running_daily_fare-1610 < 0 then 0
                    else running_daily_fare-1610
                end)
        end
        ) as refund_amount
    from daily_cumul dc
    where day >= trunc(sysdate, 'dd')+4/24 - 1 and day < trunc(sysdate, 'dd')+4/24 - 0 -- date adjust here, -1, 0 is correct
    and fare_due != 0
    order by token_id, day desc
),

daily_report as (
-- daily detailed report aggregated
    select 
        --trunc(day,'dd')+4/24,
        token_id,
        transit_account_id,
        apportioned_ets_operator,
        sum(refund_amount) as refund
    from daily_report_detailed
    where refund_amount > 0
    group by trunc(day,'dd'), transit_account_id, token_id, apportioned_ets_operator
    order by token_id, transit_account_id
),
weekly_report_detailed as (
    -- current weekly cap is $50.00
    select 
        wc.*, 
        (case
            when running_weekly_fare-5000 >= fare_due then fare_due
            when running_weekly_fare-5000 < 0 then 0
            else running_weekly_fare-5000
        end) as refund_amount
    from weekly_cumul wc
    where fare_due != 0
    order by token_id
),
weekly_report as (
-- weekly detailed report aggregated
    select 
        token_id,
        transit_account_id,
        apportioned_ets_operator,
        sum(refund_amount) as refund
    from weekly_report_detailed
    where refund_amount > 0
    group by transit_account_id, token_id, apportioned_ets_operator
    order by token_id, transit_account_id
),
adjustments_detailed as (
    select
        journal_entry_id,
        transit_account_id,
        regexp_substr(reference_info, '[^-]+', 1, 1) as adjustment_Type,
        --regexp_substr(reference_info, '[^-]+$', 1, 1) as trip_id,  --replaced based on email from Michael (see line below)
		regexp_replace(regexp_substr(reference_info, '[^-]+$', 1, 1),'\D', '') as trip_id,
        transaction_dtm+11/24 as transaction_dtm,
        transaction_amt,
        reference_info
    from abp_main.journal_entry
    where ((reference_info like '%CapRefund%') OR (reference_info like '%CapAdjustment%') OR (reference_info like '%DenyListRefund%'))
    and (regexp_substr(reference_info, '[^-]+$', 1, 1) ) not like '%Token%' 
    and journal_entry_type_id = 102
    and transaction_dtm > (SELECT * FROM StartDate)+4/24 - 8 --date adjust here
    --and transaction_dtm < trunc(sysdate,'DD') + 1 - (select * from dow)+4/24 
),
adjustments as (
    select 
        trip_id,
        sum(transaction_amt) refunded
    from adjustments_detailed
    group by trip_id
),
weekly_adjusted as (
    select 
        wrd.trip_id,
        wrd.day,
        wrd.token_id,
        wrd.Transit_account_id,
        wrd.apportioned_ets_operator,
        wrd.fare_due,
        wrd.refund_amount as weekly_refund_amount,
        --option A (we are using otion B for now - 20181217)
        /* 
        (case
            when ad.transaction_amt is null then 0
            else ad.transaction_amt
        end) as daily_refund_amount,
        (case
            when ad.transaction_amt is null then wrd.refund_amount
            when wrd.refund_amount-ad.transaction_amt < 0 then 0
            else wrd.refund_amount-ad.transaction_amt
        end) as final_refund_amount,
        */
        --option B
		(case
			when ad.transaction_amt is null or ad.adjustment_type not like 'DailyCapRefund%' then 0
			else ad.transaction_amt
		end) as daily_refund_amount,
        (case
            when ad.transaction_amt is null then wrd.refund_amount
            when ad.adjustment_type like 'WeeklyCap%' then 0
            when wrd.refund_amount = 0 and ad.transaction_amt != 0 then wrd.refund_amount-ad.transaction_amt
            when wrd.refund_amount-ad.transaction_amt < 0 then 0
            else wrd.refund_amount-ad.transaction_amt
        end) as final_refund_amount,
        wrd.running_weekly_fare,
        wrd.total_weekly_fare,
        ad.journal_entry_id as adjustment_journal_entry_id,
        ad.adjustment_type,
        ad.transaction_dtm,
        ad.reference_info
    from weekly_report_detailed wrd
    left join adjustments_detailed ad
    on wrd.trip_id = ad.trip_id
    order by wrd.token_id, wrd.day desc
),
workaround_1 as (
    select 
        wrd.trip_id,
        wrd.day,
        wrd.token_id,
        wrd.transit_account_id,
        wrd.apportioned_ets_operator,
        wrd.fare_due,
        wrd.refund_amount,
        case
            when wrd.fare_due=wrd.refund_amount then 0
            else 1
        end as partial_refund,
        case
            when wrd.fare_due-wrd.refund_amount > 0 then wrd.fare_due-wrd.refund_amount 
            else 0
        end as adjustment_amount,
        (select PG_RETRIEVAL_REF_NBR 
        from getRRN gr where wrd.trip_id = gr.trip_id and rownum = 1) as RRN
    from weekly_report_detailed wrd
    where refund_amount > 0
    and wrd.day > trunc(sysdate, 'dd')+4/24 -1
),
workaround_2 as (
    select 
        wa.trip_id,
        wa.day,
        wa.Token_id,
        wa.transit_account_id,
        wa.apportioned_ets_operator,
        wa.fare_due,
        wa.weekly_refund_amount,
        wa.daily_refund_amount,
        wa.final_refund_amount,
        /* replaced 20181217
		sum(wa.final_refund_amount) over (partition by trunc(day-4/24,'dd'), token_id order by day, token_id) running_final_refund_fare,
        sum(wa.final_refund_amount) over (partition by trunc(day-4/24,'dd'), token_id) total_final_refund_fare,
        */
		sum(wa.final_refund_amount) over (partition by wa.token_id order by day, wa.token_id) running_final_refund_fare,
        sum(wa.final_refund_amount) over (partition by wa.token_id) total_final_refund_fare,
		wa.adjustment_journal_entry_id,
        (select PG_RETRIEVAL_REF_NBR 
        from getRRN gr where wa.trip_id = gr.trip_id and rownum = 1) as RRN
    from weekly_adjusted wa
    --where wa.final_refund_amount > 0 --replaced 20181217
	where final_refund_amount != 0
    order by wa.token_id
),
workaround_3 as (
    select 
        drd.*,
        (select PG_RETRIEVAL_REF_NBR 
        from getRRN gr where drd.trip_id = gr.trip_id and rownum = 1) as RRN
    from daily_report_detailed drd
    where drd.refund_amount > 0
),
workaround_4 as (
    select
        dld.token_id,
        dld.transit_account_id,
        dld.prev_transaction_dtm as "Tap On Time",
        tap.trip_id,
        dld.apportioned_ETS_Operator,
        dld.default_fare,
        dld.fare_due,
        (select PG_RETRIEVAL_REF_NBR 
        from getRRN gr where tap.trip_id = gr.trip_id and rownum = 1) as RRN
    from deny_list_detailed dld
    left join abp_main.TAP
    on tap.tap_id = dld.prev_tap_id
    where dld.default_fare = 1
)
-- weekly cap for sunday
--select * from workaround_1 
-- weekly cap
--select * from workaround_2 where total_final_refund_fare > 0 and running_final_refund_fare > 0 --updated 20181217
-- daily cap
--select * from workaround_3 
-- deny list 
--select * from workaround_4
--confirm adjustment
--select * from adjustments_detailed ad
--where ad.transaction_dtm > trunc(sysdate)
--order by transaction_dtm desc