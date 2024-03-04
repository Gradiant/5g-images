## PacketRusher image

Docker image of open-source project [PacketRusher](https://github.com/HewlettPackard/PacketRusher)

To be able to run this image, you have to:
- Use Ubuntu 20.04 with gtp5g kernel module installed. 
- Run the container with cap_add=all
- Run the container with privileged=true

The image receives the mode of PacketRusher (ue, multi-ue...) as a command. entrypoint can be seen to understand how it works.

You can change the config file using env variables.