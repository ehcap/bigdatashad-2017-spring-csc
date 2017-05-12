ADD JAR /opt/cloudera/parcels/CDH-5.9.0-1.cdh5.9.0.p0.23/lib/hive/lib/hive-contrib.jar;

select  date_hour,
    count(1) as click_count
    from (Select date, hour(date) as date_hour from part_parsed_text_log
            where day ='2017-04-01'
            and status=200) a
    group by a.date_hour
    order by click_count desc
    LIMIT 10;


