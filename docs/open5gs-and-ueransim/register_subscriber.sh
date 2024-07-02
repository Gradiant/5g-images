#!/bin/bash

MONGO_CONTAINER=open5gs-and-ueransim-mongo-1

: 'open5gs-dbctl: Open5GS Database Configuration Tool (0.10.3)
    FLAGS: --db_uri=mongodb://localhost
    COMMANDS: >&2
       add {imsi key opc}: adds a user to the database with default values
       add {imsi ip key opc}: adds a user to the database with default values and a IPv4 address for the UE
       addT1 {imsi key opc}: adds a user to the database with 3 differents apns
       addT1 {imsi ip key opc}: adds a user to the database with 3 differents apns and the same IPv4 address for the each apn
       remove {imsi}: removes a user from the database
       reset: WIPES OUT the database and restores it to an empty default
       static_ip {imsi ip4}: adds a static IP assignment to an already-existing user
       static_ip6 {imsi ip6}: adds a static IPv6 assignment to an already-existing user
       type {imsi type}: changes the PDN-Type of the first PDN: 1 = IPv4, 2 = IPv6, 3 = IPv4v6
       help: displays this message and exits
       default values are as follows: APN \"internet\", dl_bw/ul_bw 1 Gbps, PGW address is 127.0.0.3, IPv4 only
       add_ue_with_apn {imsi key opc apn}: adds a user to the database with a specific apn,
       add {imsi key opc apn sst sd}: adds a user to the database with a specific apn, sst and sd
       update_apn {imsi apn slice_num}: adds an APN to the slice number slice_num of an existent UE
       update_slice {imsi apn sst sd}: adds an slice to an existent UE
       showall: shows the list of subscriber in the db
       showpretty: shows the list of subscriber in the db in a pretty json tree format
       showfiltered: shows {imsi key opc apn ip} information of subscriber
       ambr_speed {imsi dl_value dl_unit ul_value ul_unit}: Change AMBR speed from a specific user and the  unit values are \"[0=bps 1=Kbps 2=Mbps 3=Gbps 4=Tbps ]\"
       subscriber_status {imsi subscriber_status_val={0,1} operator_determined_barring={0..8}}: Change TS 29.272 values for Subscriber-Status (7.3.29) and Operator-Determined-Barring (7.3.30)
'

docker cp open5gs-dbctl $MONGO_CONTAINER:/

docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add 999700000000001 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA"

docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add 999700000000002 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA"

docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add 999700000000003 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA"

docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add 999700000000011 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA"

docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add 999700000000012 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA"

docker run -ti --rm \
    --net open5gs-and-ueransim_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add 999700000000013 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA"
