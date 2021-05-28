For upf function we need gtp5g kernel module in the host.

Kernel Host must be upper than 5.4.

you can clone https://github.com/free5gc/gtp5g and run:

```
make clean && make
make install
```