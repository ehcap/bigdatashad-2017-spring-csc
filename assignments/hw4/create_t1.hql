ADD JAR /opt/cloudera/parcels/CDH-5.9.0-1.cdh5.9.0.p0.23/lib/hive/lib/hive-contrib.jar;
CREATE EXTERNAL TABLE access_log_raw (
    ip STRING,
    date STRING,
    url STRING,
    status STRING,
    response_size STRING,
    referer STRING,
    user_agent STRING
)
PARTITIONED BY (day string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
    "input.regex" = "([\\d\\.:]+) - - \\[(\\S+) [^\"]+\\] \"\\w+ ([^\"]+) HTTP/[\\d\\.]+\" (\\d+) \\d+ \"([^\"]+)\" \"(.*?)\""
)
STORED AS TEXTFILE;

ALTER TABLE access_log_raw ADD PARTITION(day='2017-04-01') LOCATION '/user/bigdatashad/hw4_logs/2017-04-01';
ALTER TABLE access_log_raw ADD PARTITION(day='2017-04-02') LOCATION '/user/bigdatashad/hw4_logs/2017-04-02';
ALTER TABLE access_log_raw ADD PARTITION(day='2017-04-03') LOCATION '/user/bigdatashad/hw4_logs/2017-04-03';
ALTER TABLE access_log_raw ADD PARTITION(day='2017-04-04') LOCATION '/user/bigdatashad/hw4_logs/2017-04-04';
ALTER TABLE access_log_raw ADD PARTITION(day='2017-04-05') LOCATION '/user/bigdatashad/hw4_logs/2017-04-05';
ALTER TABLE access_log_raw ADD PARTITION(day='2017-04-06') LOCATION '/user/bigdatashad/hw4_logs/2017-04-06';
ALTER TABLE access_log_raw ADD PARTITION(day='2017-04-07') LOCATION '/user/bigdatashad/hw4_logs/2017-04-07';
ALTER TABLE access_log_raw ADD PARTITION(day='2017-04-08') LOCATION '/user/bigdatashad/hw4_logs/2017-04-08';
ALTER TABLE access_log_raw ADD PARTITION(day='2017-04-09') LOCATION '/user/bigdatashad/hw4_logs/2017-04-09';

SET hive.exec.compress.output=true;
SET io.seqfile.compression.type=BLOCK;

CREATE TABLE parsed_text_log (
    ip STRING,
    date TIMESTAMP,
    status SMALLINT,
    url STRING,
    resp_size INT,
    referer STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n'
STORED AS SEQUENCEFILE;

INSERT OVERWRITE TABLE parsed_text_log
SELECT
    ip,
    from_unixtime(unix_timestamp(date ,'dd/MMM/yyyy:HH:mm:ss')),
    CAST(status AS smallint),
    url,
    CAST(response_size AS smallint),
    referer
FROM access_log_raw;

CREATE TABLE part_parsed_text_log (
    ip STRING,
    date TIMESTAMP,
    status SMALLINT,
    url STRING,
    resp_size INT,
    referer STRING
)
PARTITIONED BY (day string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n'
STORED AS SEQUENCEFILE;

set hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE part_parsed_text_log PARTITION(day)
SELECT
    ip,
    from_unixtime(unix_timestamp(date ,'dd/MMM/yyyy:HH:mm:ss')),
    CAST(status AS smallint),
    url,
    CAST(response_size AS smallint),
    referer, day
FROM access_log_raw distribute by day;

Partition sgerasimov.part_parsed_text_log{day=2017-04-01} stats: [numFiles=1, numRows=7673862, totalSize=1414314908, rawDataSize=1293801377]
Partition sgerasimov.part_parsed_text_log{day=2017-04-02} stats: [numFiles=1, numRows=8021513, totalSize=1477749111, rawDataSize=1351788704]
Partition sgerasimov.part_parsed_text_log{day=2017-04-03} stats: [numFiles=1, numRows=11992823, totalSize=2210798512, rawDataSize=2022452008]
Partition sgerasimov.part_parsed_text_log{day=2017-04-04} stats: [numFiles=1, numRows=13686305, totalSize=2524135373, rawDataSize=2309177160]
Partition sgerasimov.part_parsed_text_log{day=2017-04-05} stats: [numFiles=1, numRows=14154107, totalSize=2609737318, rawDataSize=2387441392]
Partition sgerasimov.part_parsed_text_log{day=2017-04-06} stats: [numFiles=1, numRows=12773258, totalSize=2354138077, rawDataSize=2153547354]
Partition sgerasimov.part_parsed_text_log{day=2017-04-07} stats: [numFiles=1, numRows=11651976, totalSize=2147478737, rawDataSize=1964487091]
Partition sgerasimov.part_parsed_text_log{day=2017-04-08} stats: [numFiles=1, numRows=7669210, totalSize=1412988762, rawDataSize=1292553688]
Partition sgerasimov.part_parsed_text_log{day=2017-04-09} stats: [numFiles=1, numRows=7875214, totalSize=1450754268, rawDataSize=1327088714]
MapReduce Jobs Launched:
Stage-Stage-1: Map: 11  Reduce: 17   Cumulative CPU: 7714.94 sec   HDFS Read: 1079357297 HDFS Write: 17602096122 SUCCESS
Total MapReduce CPU Time Spent: 0 days 2 hours 8 minutes 34 seconds 940 msec

select min(ip) from parsed_text_log where date >='2017-04-01' and date <= '2017-04-02'