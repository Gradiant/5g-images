#!/bin/bash

CONTAINER_NAME=open5gs_mongo_1

docker cp imsi1.json $CONTAINER_NAME:/tmp
docker exec $CONTAINER_NAME mongoimport --db open5gs --collection subscribers --file /tmp/imsi1.json --type json --jsonArray
