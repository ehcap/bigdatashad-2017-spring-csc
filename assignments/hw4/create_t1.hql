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

select min(ip) from parsed_text_log where date >='2017-04-01' and date <= '2017-04-02'