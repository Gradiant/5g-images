# open5gs and srsRAN

5G end to end communication demo with open5gs, srsRANProject and srsUE (srsRAN4G).

# GNB config options

By default, the driver name and arguments are:

```
DEVICE_DRIVER=uhd 
DEVICE_ARGS=type=b200,num_recv_frames=64,num_send_frames=64 
```

When using DEVICE_DRIVER=zmq and setting DEVICE_ARGS=default, the default values that will be used for zmq are:
```
device_args: tx_port=tcp://${GNB_ADDRESS}:2000,rx_port=tcp://${UE_ADDRESS}:2001,id=gnb,base_srate=${SRATE}e6
```

If different DEVICE_ARGS are set with ZMQ, ensure that they match the addresses of the GNB and UE devices.

# Deployment of the core and register subscribers

deploy the core (open5gs) with:

```
docker compose -f core.yaml up -d
```

Register subscriber in ngc with `./register_subscriber.sh`.


# Deployment RAN

Deploy with

```
docker compose -f gnb.yaml up -d
```

# Test

To test srsUE connectivity through srsRAN5G, you have to change the default route:

```
docker compose -f gnb.yaml exec ue ip route replace default via 10.45.0.1
```

Then you can traceroute to internet and check first hop is through UPF:

```
docker compose -f gnb.yaml exec ue traceroute google.es
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
docker compose -f gnb.yaml down
docker compose -f core.yaml down -v

```
