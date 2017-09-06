#!/bin/bash

pair=($(head -n 1 client.properties | tr '=' ' '))
chroot=${pair[1]}

# zookeeper
echo "$ZK_QUORUM$chroot" > client.properties
