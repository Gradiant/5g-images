# open5gs and srsLTE 

5G end to end communication demo with open5gs and srsLTE.

# Deployment EPC and register subscribers

deploy the EPC core (open5gs) with:

```
    docker compose -f epc.yaml up -d
```

Register subscriber in ngc with `./register_subscriber.sh`.


# Deployment RAN

Deploy with

```
docker compose -f srslte.yaml up -d
```

# Test

To test ue connectivity through RAN, you have to change the default route through the epc pgw:

```
docker compose -f srslte.yaml exec ue ip route replace default via 10.45.0.1
```

Then you can traceroute to internet and check first hop is through pgw:

```
docker compose -f srslte.yaml exec ue traceroute google.es
traceroute to google.es (142.250.184.163), 30 hops max, 60 byte packets
 1  10.45.0.1 (10.45.0.1)  16.484 ms  16.507 ms  16.542 ms
 2  172.20.0.1 (172.20.0.1)  16.576 ms  16.631 ms  16.752 ms
 3  10.5.0.254 (10.5.0.254)  16.684 ms  16.720 ms  23.203 ms
 4  193.146.211.1 (193.146.211.1)  25.305 ms  25.371 ms  25.427 ms
 5  * * *
```


# Clean Up

Undeploy with:

```
docker compose -f srslte.yaml down
docker compose -f epc.yaml down -v

```
