#!/usr/bin/env bash
DATE=$1
#Step 1

if hdfs dfs -ls hw1/out_group1/${DATE}/_SUCCESS >/dev/null 2>&1; then
   echo "Some data fo $DATE exists. Exit"
   exit 1
fi
hdfs dfs -rm -f -r -skipTrash out_tmp*
#Step 1 Create distinctuser

#Step 1
hadoop jar /opt/hadoop/hadoop-streaming.jar \
    -files /home/sgerasimov/hw/hw1/map_filter200.py,/home/sgerasimov/hw/hw1/reduceTotalUsersHits.py \
    -input /user/sandello/logs/access.log.${DATE} \
    -output out_tmp1/${DATE} \
    -mapper ./map_filter200.py \
    -reducer ./reduceTotalUsersHits.py
if [ "$?" != "0" ]; then
     exit 1
fi

#Step 2
hadoop jar /opt/hadoop/hadoop-streaming.jar \
    -D mapreduce.job.reduces=1 \
    -files /home/sgerasimov/hw/hw1/noneWork.py,/home/sgerasimov/hw/hw1/reduceTotalUsersHits2.py \
    -input out_tmp1/${DATE} \
    -output hw1/out_group1/${DATE} \
    -mapper ./noneWork.py \
    -reducer ./reduceTotalUsersHits2.py
if [ "$?" != "0" ]; then
     exit 1
fi
#copy result to local fs
hdfs dfs -cat hw1/out_group1/${DATE}/part-00000 > /home/sgerasimov/out/hw1/${DATE}.metric1

#Step 3 - TopN request
# Map Filter& Sort Request with value 1
#hadoop jar /opt/hadoop/hadoop-streaming.jar \
#    -files /home/sgerasimov/hw/hw1/map_filter200.py,/home/sgerasimov/hw/hw1/reduceTotalUsersHits.py \
#    -input /user/sandello/logs/access.log.${DATE} \
#    -output out_tmp2/${DATE} \
#    -mapper './map_filter200.py request'\
#    -reducer ./reduceTotalUsersHits.py
#
#
#    -D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
#    -D mapred.text.key.comparator.options=-nr \
#

# Reduce - Aggregate for Request
# Map - Inverse key and value and Sort with value
# Reduce - One reducer Agg by value

