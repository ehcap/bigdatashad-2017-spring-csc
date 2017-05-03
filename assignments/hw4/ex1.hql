USE SGERASIMOV;
ADD JAR /opt/cloudera/parcels/CDH-5.9.0-1.cdh5.9.0.p0.23/lib/hive/lib/hive-contrib.jar;
set DATE='2017-04-05';
select  ip ,
    date ,
    status ,
    url ,
    referer, user_agent from parsed_text_log
    where parsed_text_log.ip in (select min(ip) from parsed_text_log in_query
                                    where in_query.date >='${DATE}' and in_query.date <date_add('${DATE}',1)
                                      and in_query.status=200)
      and date >='${DATE}' and date <date_add('${DATE}',1)
      and status=200
    ORDER BY DATE
    LIMIT 1;

USE SGERASIMOV;
ADD JAR /opt/cloudera/parcels/CDH-5.9.0-1.cdh5.9.0.p0.23/lib/hive/lib/hive-contrib.jar;
set DATE='2017-04-05';
select count(*),date_add('${DATE}',1) from parsed_text_log in_query
                                    where in_query.date >='${DATE}' and in_query.date < date_add('${DATE}',1)
                                      and in_query.status=200;
