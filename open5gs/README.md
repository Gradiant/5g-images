# Open5gs Docker Image

open5gs is a docker image to deploy a Open5gs services as a containers.

## Usage

The image default CMD launches `/bin/bash`.
image version 1.2.4 include following binaries:
 - open5gs-hssd
 - open5gs-mmed
 - open5gs-pcrfd
 - open5gs-pgwd
 - open5gs-sgwd

It includes generic configurations in `/opt/open5gs/etc/open5gs/` and in `/opt/open5gs/etc/freeDiameter`.

Data plane services need `/dev/ogstun` tun device access. You can create the tun interface in your host and mount it in the container or you can run container in privileged mode.

Some services must have access to a mongo db. You can modify the container environment variable `DB_URI=mongodb://mongo/open5gs` to configure access to mongodb.

### Docker Compose example to deploy EPC

We provide a `docker-compose_epc.yaml` file to deploy open5gs v1.2.4 epc.
Just run `docker-compose -f docker-compose_epc.yaml up -d` and check the services are up with `docker-compose -f docker-compose_epc.yaml ps`.
Sometimes services may start with error due to dependencies with other services. Just keep trying with `docker-compose up -d` multiple times. 


### Docker Compose example to deploy EPC

We provide a `docker-compose_ngc.yaml` file to deploy open5gs ngc.
Just run `docker-compose -f docker-compose_ngc.yaml up -d` and check the services are up with `docker-compose -f docker-compose_ngc.yaml ps`.
Sometimes services may start with error due to dependencies with other services. Just keep trying with `docker-compose up -d` multiple times. 