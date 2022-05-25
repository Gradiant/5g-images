# Open5gs Container Image

This repository provides a container image to deploy [Open5gs](https://open5gs.org/) services as a containers.

[Open5gs](https://open5gs.org/) is an open source project of 5GC and EPC (Release-16).

This project can be used to configure your own NR/LTE network. If gNB/eNB and USIM are available, you can build a private network using Open5GS.

Open5GS implemented 5GC and EPC using C-language. And WebUI is provided for testing purposes and is implemented in Node.JS and React.

## Usage

The idea is to deploy a container image for each of the core network services (i.e. hss, sgwc, amf, etc.). The image default CMD launches `/bin/bash`, so the recommendation is to change the command to `open5gs-hssd`, `open5gs-sgwcd`, `open5gs-amfd` or the corresponding daemon for the service you want to deploy. 

The daemons take their configuration from the `/opt/open5gs/etc/open5gs/` and the `/opt/open5gs/etc/freeDiameter` image folders.
The folders include minimal working configurations for all the services.
The original open5gs configuration files are also provided at `/opt/open5gs/etc/orig`, with comments on available parameters.

Data plane service upf needs `/dev/ogstun` tun device access. You can create the tun interface in your host and mount it in the container or you can run upf container in privileged mode.

Some services must have access to a mongodb. You can modify the container environment variable `DB_URI=mongodb://mongo/open5gs` to configure access to mongodb.

### Deployment with Docker Compose

We provide a `docker-compose.yaml` file to deploy open5gs.

Just run `docker-compose up -d` and check the services are up with `docker-compose ps`.

To remove the containers run `docker-compose down`.

