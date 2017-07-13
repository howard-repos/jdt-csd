#!/usr/bin/env python
import os
import subprocess

nodes=[]

file = open("peer.properties")
for line in file:
	line=line.strip('\n')
	host=line.split(":")[0]
	port=line.split(":")[1].split("=")[1]
	nodes.append("%s:%s"%(host,port))
file.close()
mongodbDir=os.getenv('MONGODB_DIRNAME')
primary=nodes[0]
print("will use %s as primary"%(primary))
subprocess.check_call('''%s/bin/mongo %s --eval "printjson(rs.initiate())"'''%(mongodbDir,primary),shell=True)
subprocess.check_call('''%s/bin/mongo %s --eval 'rs.add("%s")' '''%(mongodbDir,primary,nodes[1]),shell=True)
subprocess.check_call('''%s/bin/mongo %s --eval 'rs.add("%s")' '''%(mongodbDir,primary,nodes[2]),shell=True)
