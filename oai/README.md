# Open Air Interface enodeB Docker Image

oai-enb is a docker image to deploy a Open Air Interface enodeB as a container.

## Usage

The image default CMD launches `lte-softmodem -O /opt/oai/etc/enb.conf`.
It provides an enb.conf file tested with an ettus B210 USRP.
You can use your own enb.conf file by mounting the file in the container path `/opt/oai/etc/enb.conf`.

If you use a uhd device you must also mount uhd images at `/usr/share/uhd/images` or use the `-uhdimages` image variant that includes the images.

To access a usb USRP you must mount device `/dev/bus/usb`. You will also need access to `/dev/net/tun`, and run container as privileged (we are working in removing this requirement). You can find details about docker run flags in the following examples.


### Example 1: with provided enb.conf

The image provides a config file tested with an ettus B210 USRP. Run it with:

```
docker run --rm -ti --privileged \
  --device /dev/net/tun:/dev/net/tun \
  -v /dev/bus/usb/:/dev/bus/usb/ \
  -v /usr/share/uhd/images:/usr/share/uhd/images \
  openverso/oai-enb:1.2.2
```

### Example 2: -uhdimages variant

If you don't have the uhd images in the host computer, you can use the -uhdimages variant.

```
docker run --rm -ti --privileged \
  --device /dev/net/tun:/dev/net/tun \
  -v /dev/bus/usb/:/dev/bus/usb/ \
  openverso/oai-enb:1.2.2-uhdimages
```

### Example 3: using an external enb.conf and config flags

You can mount your own enb.conf file and use it with the command `lte-softmodem`. 
You can also provide flags to `lte-softmodem`, for example the noS1 flag:

```
docker run --rm -ti --privileged \
  --device /dev/net/tun:/dev/net/tun \
  -v /dev/bus/usb/:/dev/bus/usb/ \
  -v $PWD/configs/enb.conf:/opt/oai/etc/enb.conf \
  -v /usr/share/uhd/images:/usr/share/uhd/images \
  openverso/oai-enb:1.2.2 lte-softmodem -O /opt/oai/etc/enb.conf --noS1

```
