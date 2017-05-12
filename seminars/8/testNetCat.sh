#!/usr/bin/env bash
spark-submit --master yarn-client --num-executors 2 --executor-cores 1 --executor-memory 2048m testNetCat.py "0.0.0.0" 28444
