#!/usr/bin/env bash
DATE=$1
DATELOST=`date -d "-15 day" +\%F`


if hdfs dfs -ls DATALAKE/group_IP_DATE/${DATE}/_SUCCESS >/dev/null 2>&1; then
   echo "Some data to $DATE exists for group4metrics. Exit"
   exit 1
fi

hdfs dfs -rm -r -f -skipTrash DATALAKE/tempgroup4/*
hdfs dfs -rm -r -f -skipTrash  DATALAKE/group_IP_DATE/$DATELOST

#TODO Try convert reduceGroup4Part.py from reduce-type to combiner-type

hadoop jar /opt/hadoop/hadoop-streaming.jar \
    -D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
    -D stream.num.map.output.key.fields=2 \
    -D mapred.text.key.comparator.options=-k1,2 \
    -D mapred.text.key.partitioner.options=-k1,1 \
    -files /home/sgerasimov/hw/hw1/map_IP_Date.py,/home/sgerasimov/hw/hw1/reduceIDDateCount.py \
    -input /user/sandello/logs/access.log.${DATE} \
    -output DATALAKE/group_IP_DATE/${DATE} \
    -mapper ./map_IP_Date.py \
    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
    -reducer ./reduceIDDateCount.py
if [ "$?" != "0" ]; then
     exit 1
fi

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
    -reducer  "./reduceGroup4Part.py $DATE"
if [ "$?" != "0" ]; then
     exit 1
fi

hadoop jar /opt/hadoop/hadoop-streaming.jar \
    -D mapreduce.job.reduces=1 \
    -files /home/sgerasimov/hw/hw1/noneWork.py,/home/sgerasimov/hw/hw1/reduceGroup4Full.py \
    -input DATALAKE/tempgroup4/${DATE} \
    -output DATALAKE/metric_group4/${DATE} \
    -mapper ./noneWork.py \
    -reducer ./reduceGroup4Full.py
if [ "$?" != "0" ]; then
     exit 1
fi

#copy result to local fs
hdfs dfs -cat DATALAKE/metric_group4/${DATE}/part-00000 > /home/sgerasimov/out/hw1/${DATE}.metric4