USE SGERASIMOV;
ADD JAR /opt/cloudera/parcels/CDH-5.9.0-1.cdh5.9.0.p0.23/lib/hive/lib/hive-contrib.jar;
set DATE='2017-04-05';
select  ip ,
    date ,
    status ,
    url ,
    referer, user_agent from part_parsed_text_log
    where part_parsed_text_log.ip in (select min(ip) from part_parsed_text_log in_query
                                    where in_query.day='${DATE}'
                                      and in_query.status=200)
      and day = '${DATE}'
      and status=200
    ORDER BY DATE
    LIMIT 1;