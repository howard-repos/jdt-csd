#!/bin/bash

shardName=$1

cat <<EOF > mongod.conf
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

if [ "$cacheSizeGB" -gt 0 ];then
	echo "            cacheSizeGB: $cacheSizeGB" >>  mongod.conf
fi

exec numactl --interleave=all $MONGODB_DIRNAME/bin/mongod -f mongod.conf
