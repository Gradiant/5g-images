# Open5GS and PacketRusher 

5G end to end communication demo with Open5GS and PacketRusher.

# Deployment NGC and register subscribers

deploy the NGC core (Open5GS) with:

```
docker compose -f ngc.yaml up -d
```

Subscriber is registered using populate container.

# Deploy PacketRusher

packetrusher.yaml is configured to deploy the basic mode of PacketRusher: 1 gNB and 1 UE

"ffffff" SD is used to match the default behaviour of Open5GS (no SD)

```
docker compose -f packetrusher.yaml up -d
```

# Test

To test UE connectivity through RAN, enter the packetrusher container:

```
docker compose -f packetrusher.yaml exec packetrusher /bin/bash
ip vrf exec vrf0000000001 ping 8.8.8.8
```
Also, you can do a iPerf test:

```
ip vrf exec vrf0000000001 iperf3 -c IPERF_SERVER
```

# Clean Up

Undeploy with:

```
docker compose -f packetrusher.yaml down
docker compose -f ngc.yaml down
```