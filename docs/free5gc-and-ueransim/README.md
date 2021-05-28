# free5gc and ueransim 

5G end to end communication demo with free5gc and ueransim.

# Deployment NGC and register subscribers

deploy the ngc core (free5gc) with:

```
docker-compose -f ngc.yaml up -d
```

Register subscribers in ngc with `/register_subscribers.sh`.


# RAN option1: 1 gnodeb and 1 ue

Deploy 1 gnodeb and 1 ue:

```
docker-compose -f 1gnb-1ue.yaml up -d
```

Undeploy with:

```
docker-compose -f 1gnb-1ue.yaml down
```

# RAN option2: 1 gnodeb and 4 ues

Deploy 1 gnodeb and 4 ues:

```
docker-compose -f 1gnb-4ue.yaml up -d
```

Undeploy with:

```
docker-compose -f 1gnb-4ue.yaml down
```

# RAN option3: 2 gnodeb and 4 ues

Deploy 2 gnodeb and 4 ues:

```
docker-compose -f 2gnb-4ue.yaml up -d
```

Undeploy with:

```
docker-compose -f 2gnb-4ue.yaml down
```



# Undeploy NGC

Run:

```
docker-compose -f ngc.yaml down
```
