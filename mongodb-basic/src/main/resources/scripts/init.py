#!/usr/bin/env python
import os
import subprocess

def readFromFile(list,file):
	file = open(file)
	for line in file:
		line=line.strip('\n')
		host=line.split(":")[0]
		port=line.split(":")[1].split("=")[1]
		list.append("%s:%s"%(host,port))

def initReplicaSet(replicaSetName,mongdNodes,arbiterNodes):
	primary=mongdNodes[0]
	print("will use %s as primary in %s"%(primary,replicaSetName))
	subprocess.check_call('''mongo %s --eval "printjson(rs.initiate())"'''%(primary),shell=True)
	for worder in mongdNodes[1:]:
		subprocess.check_call('''mongo %s --eval 'printjson(rs.add("%s"))' '''%(primary,worder),shell=True)
	for arbiter in arbiterNodes:
		subprocess.check_call('''mongo %s --eval 'printjson(rs.addArb("%s"))' '''%(primary,arbiter),shell=True)
		
shard1MongdNodes=[]
shard1ArbiterNodes=[]
shard2MongdNodes=[]
shard2ArbiterNodes=[]
shard3MongdNodes=[]
shard3ArbiterNodes=[]

readFromFile(shard1MongdNodes,"shard1_mongod.properties")
readFromFile(shard1ArbiterNodes,"shard1_arbiter.properties")
readFromFile(shard2MongdNodes,"shard2_mongod.properties")
readFromFile(shard2ArbiterNodes,"shard2_arbiter.properties")
readFromFile(shard3MongdNodes,"shard3_mongod.properties")
readFromFile(shard3ArbiterNodes,"shard3_arbiter.properties")

print("shard1 workers:")
print(shard1MongdNodes)
print("")
print("shard1 arbiters:")
print(shard1ArbiterNodes)
print("")
print("shard2 workers:")
print(shard2MongdNodes)
print("")
print("shard2 arbiters:")
print(shard2ArbiterNodes)
print("")
print("shard3 workers:")
print(shard3MongdNodes)
print("")
print("shard3 arbiters:")
print(shard3ArbiterNodes)
print("")

initReplicaSet("s1",shard1MongdNodes,shard1ArbiterNodes)
initReplicaSet("s2",shard2MongdNodes,shard2ArbiterNodes)
initReplicaSet("s3",shard3MongdNodes,shard3ArbiterNodes)

primary=nodes[0]
print("will use %s as primary"%(primary))
subprocess.check_call('''%s/bin/mongo %s --eval "printjson(rs.initiate())"'''%(mongodbDir,primary),shell=True)
subprocess.check_call('''%s/bin/mongo %s --eval 'rs.add("%s")' '''%(mongodbDir,primary,nodes[1]),shell=True)
subprocess.check_call('''%s/bin/mongo %s --eval 'rs.add("%s")' '''%(mongodbDir,primary,nodes[2]),shell=True)
