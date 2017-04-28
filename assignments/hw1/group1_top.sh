#!/usr/bin/env bash
DATE=$1

#Step 3 - TopN request
# Map Filter& Sort Request with value 1
hdfs dfs -rm -r -f -skipTrash out_tmp2
hdfs dfs -rm -r -f -skipTrash out_tmp3

hadoop jar /opt/hadoop/hadoop-streaming.jar \
    -D mapred.text.key.partitioner.options=-k1,1 \
    -files /home/sgerasimov/hw/hw1/map_filter200.py,/home/sgerasimov/hw/hw1/reduceHitPerRequest.py \
    -input /user/sandello/logs/access.log.${DATE} \
    -output out_tmp2/${DATE} \
    -mapper './map_filter200.py request' \
    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
    -reducer ./reduceHitPerRequest.py

hadoop jar /opt/hadoop/hadoop-streaming.jar \
    -D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
    -D stream.num.map.output.key.fields=2 \
    -D mapred.text.key.comparator.options="-k1,1nr -k2,2" \
    -D mapreduce.job.reduces=1 \
    -files /home/sgerasimov/hw/hw1/inverse.py \
    -input out_tmp2/${DATE} \
    -output out_tmp3/${DATE} \
    -mapper ./inverse.py \
    -reducer ./inverse.py

#copy result to local fs
hdfs dfs -cat out_tmp3/${DATE}/part-00000 > /home/sgerasimov/out/hw1/${DATE}.metric1_top

