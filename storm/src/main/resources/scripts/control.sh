#!/bin/bash


export STORM_CONF_DIR=$CONF_DIR


echo 'storm.local.dir: "/var/lib/storm"' >> storm.yaml
echo 'worker.childopts: "-Xmx1024m -XX:-UseGCOverheadLimit -XX:-PrintGCDetails"' >> storm.yaml
echo "topology.max.spout.pending: $topology_max_spout_pending" >> storm.yaml

# zk
echo "storm.zookeeper.servers:" >> storm.yaml
for ZKNode in $(echo $ZK_QUORUM | tr "," " ")
do
    pair=($(echo $ZKNode | tr ":" " "))
    zkHost=${pair[0]}
    zkPort=${pair[1]}                       
    echo "    - \"${zkHost}\"" >> storm.yaml
done

# log dir
echo "storm.log.dir: \"$LOG_DIR\"" >> storm.yaml

# ui port
if [ -n "$UI_PORT" ];then
	echo "ui.port: $UI_PORT" >> storm.yaml
fi

# nimbus
if [ -f "nimbus.properties" ];then
	pair=($(head -n 1 nimbus.properties | tr ':' ' '))
	nimbusHost=${pair[0]}
	echo "nimbus.host: \"$nimbusHost\"" >> storm.yaml
fi

CMD=$1
case $CMD in
  (supervisor)
    exec $STORM_DIRNAME/bin/storm supervisor
    ;;
  (ui)
    exec $STORM_DIRNAME/bin/storm ui
    ;;
  (nimbus)
    exec $STORM_DIRNAME/bin/storm nimbus
    ;;
  (logviewer)
    exec $STORM_DIRNAME/bin/storm logviewer
    ;;
  (*)
    echo "Don't understand [$CMD]"
    ;;
esac
