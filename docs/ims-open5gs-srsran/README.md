# IMS + OPEN5GS + SRSRAN

VoLTE demo with Kamailio IMS, Open5gs and srsRAN.

Assuming SIMs have already been properly configured and using MNC 01 and MCC 001.

# Deployment EPC and IMS components

```
docker-compose up -d
```

# Register subscribers

Register both subscribers in Open5gs and FHoSS following the instructions provided in https://github.com/MAlexVR/docker_open5gs

# Deployment RAN
Download the uhd_images folder using *uhd_image_downloader.py* script provided: 
```
python3 uhd_image_downloader.py -i uhd_images/
```

Then:

```
docker-compose -f srsenb.yaml up -d
```