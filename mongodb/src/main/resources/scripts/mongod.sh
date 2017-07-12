#!/bin/bash


cat <<EOF > mongod.conf
replication:
    replSetName: "${replSetName}"
net:
    port: ${port}
systemLog:
    destination: file
    path: "${log_dir}/mongod.log"
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
