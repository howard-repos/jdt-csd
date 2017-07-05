#!/bin/bash

# nimbus

pair=($(head -n 1 nimbus.properties | tr ':' ' '))
nimbusHost=${pair[0]}
echo "nimbus.host: \"$nimbusHost\"" >> storm.yaml

rm nimbus.properties
