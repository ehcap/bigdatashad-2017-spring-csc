#!/usr/bin/env bash
DATE=$1
hdfs dfs -rm -f -r -skipTrash DATALAKE/temp*

hadoop jar /opt/hadoop/hadoop-streaming.jar \
    -D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
    -D stream.num.map.output.key.fields=2 \
    -D mapred.text.key.comparator.options=-k1,2 \
    -D mapred.text.key.partitioner.options=-k1,1 \
    -files /home/sgerasimov/hw/hw1/noneWork.py,/home/sgerasimov/hw/hw1/reduceGroup4Part.py \
    -input DATALAKE/group_IP_DATE/*/ \
    -output DATALAKE/tempgroup4/${DATE} \
    -mapper ./noneWork.py \
    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
    -reducer "./reduceGroup4Part.py $DATE"

#hadoop jar /opt/hadoop/hadoop-streaming.jar \
#    -D mapreduce.job.reduces=1 \
#    -files /home/sgerasimov/hw/hw1/noneWork.py,/home/sgerasimov/hw/hw1/reduceTotalUsersHits2.py \
#    -input DATALAKE/group_IP_DATE/*/ \
#    -output DATALAKE/group_IP_DATE/*/ \
#    -mapper ./mapGroup4Step2.py \
#    -reducer ./reduceGroup4Full.py

