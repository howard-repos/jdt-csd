#!/bin/bash


cat <<EOF > config.conf
sharding:
   clusterRole: "configsvr"
storage:
   dbPath: "${data_dir}"
net:
   port: ${port}
systemLog:
    destination: file
    path: "${log_dir}/config.log"
    logAppend: true
EOF

CMD=$1
case $CMD in
  (config)
    exec numactl --interleave=all $MONGODB_DIRNAME/bin/mongod -f config.conf
    ;;
  (*)
    echo "Don't understand [$CMD]"
    ;;
esac
