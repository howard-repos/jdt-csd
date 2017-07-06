#!/bin/bash

# add default config
cat <<EOF > server.properties
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
num.partitions=1
num.recovery.threads.per.data.dir=1
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
log.cleaner.enable=false
zookeeper.connection.timeout.ms=6000
EOF

cat kafkaConfig.properties >> server.properties

# zk
echo "zookeeper.connect=${ZK_QUORUM}${zookeeperRoot}" >> server.properties

export KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:$CONF_DIR/log4j.properties"
export KAFKA_HEAP_OPTS="-Xmx${heap}G -Xms${heap}G"

CMD=$1
case $CMD in
  (start)
    exec ${JDT_KAFKA_DIRNAME}/bin/kafka-server-start.sh server.properties
    ;;
  (*)
    echo "Don't understand [$CMD]"
    ;;
esac
