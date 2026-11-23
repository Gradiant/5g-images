# free5GC

The image packages all network functions built by the upstream `make nfs`
target, including the UPF, and the matching configuration templates in
`/etc/free5gc`. Run the network functions as separate services. MongoDB and
the WebConsole run separately.

The configuration templates must be adapted to the deployment. The examples
using free5GC 3.0.5 refer to the legacy image and use older configuration
formats and command-line flags. See the [upstream Compose deployment][compose]
for matching configurations and commands.

The UPF requires the [gtp5g kernel module][gtp5g] on the Linux node that runs
the container. The [free5GC v4.3.0 installer][setup] uses gtp5g v0.9.16.
Install and load a compatible module on the node and give the UPF container
`NET_ADMIN`. Building the image and checking the binaries with `--help` do
not require the module.

[compose]: https://github.com/free5gc/free5gc-compose/tree/v4.3.0
[gtp5g]: https://github.com/free5gc/gtp5g
[setup]: https://github.com/free5gc/free5gc/blob/v4.3.0/quick-setup.sh
