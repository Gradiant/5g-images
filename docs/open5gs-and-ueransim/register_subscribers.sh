#!/bin/bash

CONTAINER_NAME=open5gs-and-ueransim_mongo_1

IMSI_LIST="001010000000001 001010000000002 001010000000003 001010000000004 001010000000011 001010000000012 001010000000013 001010000000014"
KI=465B5CE8B199B49FAA5F0A2EE238A6BC
OPC=E8ED289DEBA952E4283B54E88E6183CA

for IMSI in $IMSI_LIST; do  
   docker exec $CONTAINER_NAME mongo --eval "db.subscribers.update({\"imsi\" : \"$IMSI\"}, { \$setOnInsert: {\"imsi\" : \"$IMSI\",\"subscribed_rau_tau_timer\": NumberInt(12),\"network_access_mode\": NumberInt(2),\"subscriber_status\": NumberInt(0),\"access_restriction_data\": NumberInt(32),\"slice\":[{\"sst\": NumberInt(1),\"default_indicator\":true,\"session\":[{\"name\":\"internet\",\"type\":NumberInt(3),\"pcc_rule\":[],\"ambr\":{\"uplink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)},\"downlink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)}},\"qos\":{\"index\":NumberInt(9),\"arp\":{\"priority_level\":NumberInt(8),\"pre_emption_capability\":NumberInt(1),\"pre_emption_vulnerability\":NumberInt(1)}}}]}],\"ambr\":{\"uplink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)},\"downlink\":{\"value\":NumberInt(1),\"unit\":NumberInt(3)}},\"security\":{\"k\":\"$KI\",\"amf\":\"8000\",\"op\":null,\"opc\":\"$OPC\"}}}, upsert=true);" open5gs
done


