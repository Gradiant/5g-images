# Open Air Interface Docker Image

oai is a docker image to run Open Air Interface as a container.

## Usage

This docker image must be run with a command (docker run -ti openverso/oai CMD)

example of commands:
  - /opt/oai/bin/lte-softmodem.Rel15 -O /oai.conf
  - /opt/oai/bin/nr-softmodem.Rel15 -O /oai.conf
  - /opt/oai/bin/nr-uesoftmodem.Rel15 -O /oai.conf
  - /bin/bash

The entrypoint generates a /oai.conf file from a template replacing '@VAR@' placeholders with environment variable values.
This image provides predefined config templates. To choose a template, set CONFIG_TEMPLATE variable to:
  - gnb_nsa_tdd_mono
  - gnb_sa_tdd_mono
  - enb_fdd_cu
  - enb_fdd_du
  - enb_fdd_mono
  - enb_tdd_mono
  - enb_fdd_fapi_rcc
  - enb_fdd_if4p5_rcc
  - enb_tdd_if4p5_rcc
  - enb_fdd_rru
  - enb_tdd_rru
  - nr_ue
You can also mount your own template and provide the path with CONFIG_TEMPLATE_PATH environment variable.

The entrypoint does also some magic to deal with hostnames, interface names and IPs:
- It gets the IPs of the interfaces *_IF_NAME environment variables and generates corresponding *_IP_ADDRESS environment variables.
For example, if GNB_NG_IF_NAME=eth0, the IP of the eth0 is extracted and assigned to GNB_NG_IP_ADDRESS variable.

- It resolves the IPs of the names *_HOSTNAME environment variables and generates corresponding *_IP_ADDRESS environment variables.
For example, if MME_S1C_HOSTNAME=mme.openverso.org, the entrypoints resolves the IP and assigns it to MME_S1C_IP_ADDRESS variable.

Set USE_B2XX, USE_X3XX or USE_N3XX to load the USRP binaries.

### Example 1: enodeb

```
docker run --rm -ti --privileged \
  -v /dev/bus/usb/:/dev/bus/usb/ \
  -v $PWD/examples/enb.fdd.conf:/opt/oai/etc/enb.fdd.conf \
  --env-file $PWD/examples/enb-fdd.env \
  --privileged \
  openverso/oai:2021.w36 opt/oai/bin/lte-softmodem.Rel15 -O /oai.conf
```

### Example 2: gnodeb standalone

```
docker run --rm -ti --privileged \
  -v /dev/bus/usb/:/dev/bus/usb/ \
  -v $PWD/examples/gnb.sa.tdd.conf:/opt/oai/etc/gnb.sa.tdd.conf \
  --env-file $PWD/examples/gnb-sa.env \
  --privileged \
  openverso/oai:2021.w36 opt/oai/bin/nr-softmodem.Rel15 -E --sa -O /oai.conf
```


### Example 3: nr-UE

```
docker run --rm -ti --privileged \
  -v /dev/bus/usb/:/dev/bus/usb/ \
  -v $PWD/examples/nr-ue-sim.conf:/opt/oai/etc/nr-ue-sim.conf \
  --env-file $PWD/examples/nr_ue.env \
  --privileged \
  openverso/oai:2021.w36 /opt/oai/bin/nr-uesoftmodem.Rel15 -E --sa -O /oai.conf
```