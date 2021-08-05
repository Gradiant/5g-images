# open5gs and openairinterface

4G/5G end to end communication demo with open5gs and openairinterface.

# Deployment Core Network and register subscribers

deploy the 4G/5G core (open5gs) with:

```
docker-compose -f core.yaml up -d
```

Register subscribers in core with `/register_subscriber.sh`.


# Download uhd_images


python3 ../../uhd_image_downloader.py -i ../../uhd_images

# Deployment 4G RAN (enodeB)

Deploy with

```
docker-compose -f oai-enb.yaml up -d
```


# Test 4G RAN

To test 4G ue connectivity use a commercial smartphone, insert the SIM card previously registered in the core and connect to the "internet" apn.

Check the mme log. Sometimes there is an `ERROR: Invalid Action[0] (../src/mme/s1ap-handler.c:1464)` and the oai enodeb exits. Re-run enodeb `docker-compose -f oai-enb.yaml up -d` until success.

Then ue should be connected to 4G network:

<img src="ue_connected.jpg" alt="ue_connected.jpg" width="320"/>


# Clean Up

Undeploy with:

```
docker-compose -f oai-enb.yaml down
docker-compose -f core.yaml down -v
```