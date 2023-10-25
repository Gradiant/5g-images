#!/bin/bash

MONGO_CONTAINER=open5gs-and-ueransim-mongo-1

: 'open5gs-dbctl: Open5GS Database Configuration Tool (0.9.1)
COMMANDS:
   add {imsi key opc}: adds a user to the database with default values
   add {imsi ip key opc}: adds a user to the database with default values and a IPv4 address for the UE
   addT1 {imsi key opc}: adds a user to the database with 3 differents apns
   addT1 {imsi ip key opc}: adds a user to the database with 3 differents apns and the same IPv4 address for the each apn
   remove {imsi}: removes a user from the database
   reset: WIPES OUT the database and restores it to an empty default
   static_ip {imsi ip4}: adds a static IP assignment to an already-existing user
   static_ip6 {imsi ip6}: adds a static IPv6 assignment to an already-existing user
   type {imsi type}: changes the PDN-Type of the first PDN: 0 = IPv4, 1 = IPv6, 2 = IPv4v6, 3 = v4 OR v6
   help: displays this message and exits
   default values are as follows: APN "internet", dl_bw/ul_bw 1 Gbps, PGW address is 127.0.0.3, IPv4 only
'

docker cp open5gs-dbctl $MONGO_CONTAINER:/

docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    openverso/open5gs-dbctl open5gs-dbctl add 999700000000001 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA
docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    openverso/open5gs-dbctl open5gs-dbctl add 999700000000002 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA
docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    openverso/open5gs-dbctl open5gs-dbctl add 999700000000003 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA
docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    openverso/open5gs-dbctl open5gs-dbctl add 999700000000011 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA
docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    openverso/open5gs-dbctl open5gs-dbctl add 999700000000012 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA
docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    openverso/open5gs-dbctl open5gs-dbctl add 999700000000013 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA


