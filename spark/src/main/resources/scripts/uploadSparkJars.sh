#!/bin/bash

hdfs dfs -copyFromLocal -f $JDT_SPARK_DIRNAME/jars/* /sparkJars
