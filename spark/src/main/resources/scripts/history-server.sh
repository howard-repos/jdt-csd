#!/bin/bash


export SPARK_NO_DAEMONIZE=true

exec $JDT_SPARK_DIRNAME/sbin/start-history-server.sh > /dev/null 2>&1
