#!/bin/bash

cat <<EOF >> meta.conf
net:
    port: ${port}
systemLog:
    destination: file
    path: "${log_dir}/mongod.log"
    logAppend: true
storage:
    engine: "wiredTiger"
    dbPath: "${data_dir}"
    wiredTiger:
        engineConfig:
            cacheSizeGB: ${cacheSizeGB}
EOF

CMD=$1
case $CMD in
  (start)
    exec numactl --interleave=all $MONGODB_DIRNAME/bin/mongod -f meta.conf
    ;;
  (*)
    echo "Don't understand [$CMD]"
    ;;
esac
