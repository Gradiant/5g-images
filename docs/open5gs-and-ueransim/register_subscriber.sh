#!/bin/bash

CONTAINER_NAME=open5gs-and-ueransim_mongo_1

docker cp imsi.json $CONTAINER_NAME:/tmp
docker exec $CONTAINER_NAME mongoimport --db open5gs --collection subscribers --file /tmp/imsi.json --type json --jsonArray
