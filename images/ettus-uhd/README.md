# Ettus USRP Hardware Drivers (UHD)

This image provides uhd libraries, binaries, tools and examples to work with ettus USRP.

We also provide an image variant (-uhd-images) with the uhd firmware images included.


## Examples

Running uhd_usrp_probe providing uhd-images from host folder:

```
docker run --rm -ti --privileged \
  -v /dev/bus/usb/:/dev/bus/usb/ \
  -v /usr/share/uhd/images:/usr/share/uhd/images \
  openverso/ettus-uhd:3.15.0 uhd_usrp_probe

```

Running uhd_find_devices in the uhd-images variant:

```
docker run --rm -ti --privileged \
  -v /dev/bus/usb/:/dev/bus/usb/ \
  -v /usr/share/uhd/images:/usr/share/uhd/images \
  openverso/ettus-uhd:3.15.0 uhd_find_devices
```

Running uhd host example benchmark_rate:

```
docker run --rm -ti --privileged \
  -v /dev/bus/usb/:/dev/bus/usb/ \
  -v /usr/share/uhd/images:/usr/share/uhd/images \
  openverso/ettus-uhd:3.15.0 benchmark_rate --rx_rate 10e6 --tx_rate 10e6

```