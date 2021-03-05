# open5gs and srsLTE 

5G end to end communication demo with open5gs and srsLTE.

# Deployment NGC and register subscribers

deploy the ngc core (open5gs) with:

```
docker-compose -f ngc.yaml up -d
```

Register subscriber in ngc with `/register_subscriber.sh`.


# Deployment RAN

Deploy with

```
docker-compose -f srslte.yaml up -d
```

Undeploy with:

```
docker-compose -f srslte.yaml down
```