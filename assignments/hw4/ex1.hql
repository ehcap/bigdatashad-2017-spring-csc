USE SGERASIMOV;

ADD JAR /opt/cloudera/parcels/CDH-5.9.0-1.cdh5.9.0.p0.23/lib/hive/lib/hive-contrib.jar;
select  ip ,
    date ,
    status ,
    url ,
    referer from parsed_text_log
    where parsed_text_log.ip in (select min(ip) from parsed_text_log in_query
                                    where in_query.date >='2017-04-01' and in_query.date <= '2017-04-02' )
      and date >='2017-04-01' and date <= '2017-04-02'
    ORDER BY DATE
    LIMIT 1;


Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Starting Job = job_1489169098057_4592, Tracking URL = http://hadoop2-10.yandex.ru:8088/proxy/application_1489169098057_4592/
Kill Command = /u0/cloudera/parcels/CDH-5.9.0-1.cdh5.9.0.p0.23/lib/hadoop/bin/hadoop job  -kill job_1489169098057_4592
Hadoop job information for Stage-3: number of mappers: 65; number of reducers: 1
2017-04-28 08:46:24,902 Stage-3 map = 0%,  reduce = 0%
