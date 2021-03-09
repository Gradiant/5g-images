#!/bin/bash

docker-compose -f epc.yaml exec upf iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE;
docker-compose -f srslte.yaml exec ue ip route replace default via 10.45.0.1
