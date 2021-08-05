# open5gs and ueransim 

5G end to end communication demo with open5gs and ueransim.

# Deployment NGC and register subscribers

deploy the ngc core (open5gs) with:

```
docker-compose -f ngc.yaml up -d
```

Register subscribers in ngc with `/register_subscriber.sh`.


# Deploy gnodeb

gnb1.yaml is configured to deploy 1 gnodeb (gnb1) and 3 ues:

```
docker-compose -f gnb1.yaml up -d
```

You can use gnb2.yaml to deploy a second gnodeb (gnb2) with 3 additional ues:

```
docker-compose -f gnb2.yaml up -d
```


# Test

To test ue connectivity through RAN, enter the gnb1-ues container:

```
docker-compose -f gnb1.yaml exec ues /bin/bash
traceroute -i uesimtun0 google.es
ping -I uesimtun0 google.es
```
ues container will have multiple interfaces (one for each ue). 
You can try each tunnel providing the flag '-i' in traceroute and '-I' in ping.

If you have deployed a second genodeb (gnb2) just change the gnb1.yaml to gnb2.yaml.


# Clean Up

Undeploy with:

```
docker-compose -f gnb1.yaml down
docker-compose -f gnb2.yaml down
docker-compose -f epc.yaml down -v
```