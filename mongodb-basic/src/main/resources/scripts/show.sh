#!/bin/bash

port=$1

cat <<EOF > mongodbstats.js
function checkRS(members){
	var valid=true;
	members.forEach(function(member){
		print(member.name+" is "+member.stateStr)
		if (member.stateStr != "SECONDARY" && member.stateStr != "PRIMARY" && member.stateStr != "ARBITER"){
			valid=false;
		}
	});
	return valid;
}
db = db.getSiblingDB('config');
shards=db.shards.find();
print("\ncurrent shards:\n")
while ( shards.hasNext() ) {
	printjson( shards.next() );
}

print("\ncheck rs status:\n")
shards=db.shards.find();
while ( shards.hasNext() ) {
	shard=shards.next();
	print("checking "+shard._id)
	connStr=shard.host;
	mongo=new Mongo(connStr);
	rsStats=mongo.getDB("admin")._adminCommand("replSetGetStatus");
	var valid=checkRS(rsStats.members);
	if(!valid){
		print("please check this rs!!")
		printjson(rsStats)
	}
	print("")
}
EOF

$MONGODB_DIRNAME/bin/mongo localhost:$port mongodbstats.js --quiet | grep -v "I NETWORK"
