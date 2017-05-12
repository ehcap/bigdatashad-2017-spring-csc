#!/usr/bin/env python
import sys
from pyspark import SparkContext
from pyspark.streaming import StreamingContext


def parseLine(line):
    split_values = line.split(' ')
    return (split_values[0], 1)


if __name__ == "__main__":
    sc = SparkContext(appName="PythonStreamingWC")
    ssc = StreamingContext(sc, 10)

    lines = ssc.socketTextStream(sys.argv[1], int(sys.argv[2]))
    objects = lines.map(parseLine).reduceByKey(lambda a, b: a + b)
    print("--------------------------------------------")
    objects.pprint()
    objects.saveAsTextFiles('testout')
    ssc.start()
    ssc.awaitTermination()