# tailscale-docker-router
Bridge container for connecting Docker networks to Tailscale with port forwarding

[Docker Hub link](https://hub.docker.com/r/cjbentley/tailscale-docker-router)

## Usage
I have a docker-compose stack that I wish to expose to my Tailscale network in a host-agnostic manner. This container acts as the bridge between the internal Docker network and Tailscale, by configuring iptables rules that forward content received on arbitrary ports from the Tailscale container to the relevant container in the Docker network. 

![This is my Synology for example](images/synology-example)

In this example, the `tailscale` container ports 80 and 443 are linked to the `caddy` container ports 80 and 443, similar for DNS/DHCP on the `pi-hole` container. These hostnames are resolved by the script to make it resilient to changes in the Docker network's IP allocations, etc.

This container is built on the official [tailscale/tailscale](https://hub.docker.com/r/tailscale/tailscale) image. Therefore, you'll want to use the same volume links, such as mapping `/var/lib` to preserve Tailscale's state. The container also requires the same elevated privileges. An example docker-compose file is available on [Richard North's blog](https://rnorth.org/tailscale-docker/). 

The only unique configuration is specifying the destination for port forwarding using environment variables starting with `custom_`. 

## Issues/Enhancements
Here are a few things I'd like to do, but the container is good enough for my own personal use, so I will probably not work on it much longer. Pull requests are welcome of course.
- Be a bit more careful with getting the right IPs for iptables rules (the current setup may not work with multiple networks assigned to the tailscale-docker-router container - ymmv) 
- Properly check if tailscale link is up before running iptables configuration (currently we rely on 5sec sleep)
- Stop using bashisms to remove need for bash installation (reducing image size)