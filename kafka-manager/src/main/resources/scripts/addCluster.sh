#!/bin/bash

port=$1

# zk
export ZK_HOSTS=$ZK_QUORUM

curl -s localhost:${port}/clusters --data "name=neu&zkHosts=${ZK_HOSTS}/kafka&kafkaVersion=0.8.2.1&jmxEnabled=true" -X POST >/dev/null
