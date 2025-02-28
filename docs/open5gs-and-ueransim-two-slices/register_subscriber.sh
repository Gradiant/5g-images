#!/bin/bash

MONGO_CONTAINER=open5gs-and-ueransim-two-slices-mongo-1

: 'open5gs-dbctl: Open5GS Database Configuration Tool (0.10.3)
    FLAGS: --db_uri=mongodb://localhost
    COMMANDS: >&2
       echo "open5gs-dbctl: Open5GS Database Configuration Tool ($version)"
    echo "FLAGS: --db_uri=mongodb://localhost"
    echo "COMMANDS:" >&2
    echo "   add {imsi key opc}: adds a user to the database with default values"
    echo "   add {imsi ip key opc}: adds a user to the database with default values and a IPv4 address for the UE"
    echo "   addT1 {imsi key opc}: adds a user to the database with 3 differents apns"
    echo "   addT1 {imsi ip key opc}: adds a user to the database with 3 differents apns and the same IPv4 address for the each apn"
    echo "   remove {imsi}: removes a user from the database"
    echo "   reset: WIPES OUT the database and restores it to an empty default"
    echo "   static_ip {imsi ip4}: adds a static IP assignment to an already-existing user"
    echo "   static_ip6 {imsi ip6}: adds a static IPv6 assignment to an already-existing user"
    echo "   type {imsi type}: changes the PDN-Type of the first PDN: 1 = IPv4, 2 = IPv6, 3 = IPv4v6"
    echo "   help: displays this message and exits"
    echo "   default values are as follows: APN \"internet\", dl_bw/ul_bw 1 Gbps, PGW address is 127.0.0.3, IPv4 only"
    echo "   add_ue_with_apn {imsi key opc apn}: adds a user to the database with a specific apn,"
    echo "   add_ue_with_slice {imsi key opc apn sst sd}: adds a user to the database with a specific apn, sst and sd"
    echo "   update_apn {imsi apn slice_num}: adds an APN to the slice number slice_num of an existent UE"
    echo "   update_slice {imsi apn sst sd}: adds an slice to an existent UE"
    echo "   showall: shows the list of subscriber in the db"
    echo "   showpretty: shows the list of subscriber in the db in a pretty json tree format"
    echo "   showfiltered: shows {imsi key opc apn ip} information of subscriber"
    echo "   ambr_speed {imsi dl_value dl_unit ul_value ul_unit}: Change AMBR speed from a specific user and the  unit values are \"[0=bps 1=Kbps 2=Mbps 3=Gbps 4=Tbps ]\""
    echo "   subscriber_status {imsi subscriber_status_val={0,1} operator_determined_barring={0..8}}: Change TS 29.272 values for Subscriber-Status (7.3.29) and Operator-Determined-Barring (7.3.30)"
}
'

docker cp open5gs-dbctl $MONGO_CONTAINER:/

docker run -ti --rm \
    --net open5gs-and-ueransim-two-slices_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add_ue_with_slice 999700000000001 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 0x111111"

docker run -ti --rm \
    --net open5gs-and-ueransim-two-slices_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add_ue_with_slice 999700000000002 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 0x111111"

docker run -ti --rm \
    --net open5gs-and-ueransim-two-slices_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add_ue_with_slice 999700000000003 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 0x111111"

docker run -ti --rm \
    --net open5gs-and-ueransim-two-slices_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add_ue_with_slice 999700000000011 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 2 0x222222"

docker run -ti --rm \
    --net open5gs-and-ueransim-two-slices_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add_ue_with_slice 999700000000012 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 2 0x222222"

docker run -ti --rm \
    --net open5gs-and-ueransim-two-slices_default \
    -e DB_URI=mongodb://$MONGO_CONTAINER/open5gs \
    gradiant/open5gs-dbctl:0.10.3 "open5gs-dbctl add_ue_with_slice 999700000000013 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 2 0x222222"
