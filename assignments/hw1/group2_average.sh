#!/usr/bin/env bash
DATE=$1

#Step AverageUser
# Map Filter& Sort Request with value 1
hdfs dfs -rm -r -f -skipTrash out_grp2*

hadoop jar /opt/hadoop/hadoop-streaming.jar \
    -D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
    -D stream.num.map.output.key.fields=2 \
    -D mapred.text.key.comparator.options=-k1,2 \
    -D mapred.text.key.partitioner.options=-k1,1 \
    -files /home/sgerasimov/hw/hw1/map_IP_RequestTime.py,/home/sgerasimov/hw/hw1/reduceAverageTimeRequest.py \
    -input /user/sandello/logs/access.log.${DATE} \
    -output out_grp2_1/${DATE} \
    -mapper ./map_IP_RequestTime.py \
    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
    -reducer ./reduceAverageTimeRequest.py

hadoop jar /opt/hadoop/hadoop-streaming.jar \
    -D mapreduce.job.reduces=1 \
    -files /home/sgerasimov/hw/hw1/reduceGroup2Step2.py,/home/sgerasimov/hw/hw1/mapGroup2Step2.py \
    -input out_grp2_1/${DATE} \
    -output out_grp2_2/${DATE} \
    -mapper ./mapGroup2Step2.py \
    -reducer ./reduceGroup2Step2.py

hdfs dfs -cat out_grp2_2/${DATE}/part-00000 > /home/sgerasimov/out/hw1/${DATE}.metric2
