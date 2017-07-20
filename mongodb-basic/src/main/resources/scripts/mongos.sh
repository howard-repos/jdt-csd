#!/bin/bash

cat <<EOF > joinConfigServer.py
#!/usr/bin/env python
nodes=[]
file = open("configServer.properties")
for line in file:
	line=line.strip('\n')
	host=line.split(":")[0]
	port=line.split(":")[1].split("=")[1]
	nodes.append("%s:%s"%(host,port))
	
# make sure use the same order
nodes.sort()
print (",".join(nodes))
EOF

chmod +x joinConfigServer.py

configDB=$(./joinConfigServer.py)

cat <<EOF > mongos.conf
sharding:
    configDB: "${configDB}"
net:
    port: ${port}
systemLog:
    destination: file
    path: "${log_dir}/mongos.log"
    logAppend: true
EOF


# wait config server to start
sleep 5

exec numactl --interleave=all $MONGODB_DIRNAME/bin/mongos -f mongos.conf
