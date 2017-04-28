#!/usr/bin/env bash
DATE=$1

if hdfs dfs -ls DATALAKE/group_IP_DATE/${DATE}/_SUCCESS >/dev/null 2>&1; then
   echo "Some data to $DATE exists for group4metrics. Exit"
   exit 1
fi

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
