# open5gs and srsLTE 

5G end to end communication demo with open5gs and srsLTE.

# Deployment EPC and register subscribers

deploy the EPC core (open5gs) with:

```
docker-compose -f epc.yaml up -d
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