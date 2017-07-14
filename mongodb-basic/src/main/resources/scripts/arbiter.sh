#!/bin/bash

shardName=$1

cat <<EOF > arbiter.conf
replication:
    replSetName: "${shardName}"
net:
    port: ${port}
systemLog:
    destination: file
    path: "${log_dir}/${shardName}.log"
    logAppend: true
storage:
    dbPath: "${data_dir}"
    engine: "wiredTiger"
    wiredTiger:
        engineConfig:
            directoryForIndexes: true
EOF


exec numactl --interleave=all $MONGODB_DIRNAME/bin/mongod -f arbiter.conf
