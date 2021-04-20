# open5gs and openairinterface enodeb 

5G end to end communication demo with open5gs and openairinterface enodeb.

# Deployment EPC and register subscribers

deploy the EPC core (open5gs) with:

```
docker-compose -f epc.yaml up -d
```

Register subscriber in epc with `/register_subscriber.sh`.


# Download uhd_images


python3 uhd_image_downloader.py -i ./uhd_images

# Deployment RAN (enodeB)

Deploy with

```
docker-compose -f oai-enb.yaml up -d
```

Undeploy with:

```
docker-compose -f oai-enb.yaml down
```
