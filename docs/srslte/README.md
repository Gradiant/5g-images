# srsLTE Mobile Network 

4G end to end communication demo with srsLTE components.

# Deployment

docker-compose.yaml defines 3 services/containers: epc, enodeb and ue. 

deploy with
```
docker-compose up -d
```

Check if enodeb and ue registered in epc logs:
```
docker-compose logs epc
```

Check interfaces in ue container, a tun_srsue interface should be created after succesful registration:
```
docker-compose exec ue ip addr list
```

Change default route in ue container and check if internet connectivity is provided through apn (10.45.0.1):
```
docker-compose exec ue /bin/bash
ip route replace default via 10.45.0.1
traceroute google.es
```