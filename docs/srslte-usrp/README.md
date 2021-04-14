# srsLTE Mobile Network 

4G end to end communication demo with srsLTE components and an USRP.

# Requirements
enodeb container is configured to have access to the host USB. You must plug an USRP to the host USB to try this demo.
Alsdo uhd images must be available in `uhd_images folder`. You can run `python3 uhd_image_downloader.py -i uhd_images` to download the images.

You have to include user information (IMSI,KEY,OPC) in srs-config/user_db.csv file.
You have to set the corresponding MNC and MCC in docker-compose.yaml.

# Deployment

docker-compose.yaml defines 2 services/containers: epc, enodeb. 

deploy with
```
docker-compose up -d
```

Connect with a commercial 4G phone.
