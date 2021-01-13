# Open5gs Docker Image

open5gs is a docker image to deploy a Open5gs services as a containers.

## Usage

The image default CMD launches `/bin/bash`.

It includes working configurations in `/opt/open5gs/etc/open5gs/` and in `/opt/open5gs/etc/freeDiameter`.
Also original open5gs configuration files are provided at `/opt/open5gs/etc/orig`, with comments on available parameters.

Data plane service upf need `/dev/ogstun` tun device access. You can create the tun interface in your host and mount it in the container or you can run container in privileged mode.

Some services must have access to a mongodb. You can modify the container environment variable `DB_URI=mongodb://mongo/open5gs` to configure access to mongodb.

### Deployment with Docker Compose

We provide a `docker-compose.yaml` file to deploy open5gs.
Just run `docker-compose up -d` and check the services are up with `docker-compose ps`.

To remove the containers run `docker-compose down`.