#!/bin/bash

rm -f /tmp/kafkaManagerPID

# zk
export ZK_HOSTS=$ZK_QUORUM

CMD=$1
case $CMD in
  (start)
    exec ${KAFKA_MANAGER_DIRNAME}/bin/kafka-manager -Dpidfile.path=/tmp/kafkaManagerPID -Dlogger.file=${CONF_DIR}/logback.xml \
    -Dhttp.port=${port} >/dev/null 2>&1
    ;;
  (*)
    echo "Don't understand [$CMD]"
    ;;
esac
