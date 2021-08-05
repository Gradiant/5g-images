# open5gs and srsLTE 

5G end to end communication demo with open5gs and srsLTE.

# Deployment EPC and register subscribers

deploy the EPC core (open5gs) with:

```
docker-compose -f epc.yaml up -d
```

Register subscriber in ngc with `/register_subscriber.sh`.


# Download uhd_images


python3 ../../uhd_image_downloader.py -i ../../uhd_images

# Deployment RAN (enodeB)

Deploy with

```
docker-compose -f srs-enb.yaml up -d
```


# Test

To test ue connectivity use a commercial smartphone, insert the SIM card previously registered in the EPC and connect to the "internet" apn.

<img src="ue_connected.jpg" alt="ue_connected.jpg" width="320"/>


# Clean Up

Undeploy with:

```
docker-compose -f srslte.yaml down
docker-compose -f epc.yaml down -v

```