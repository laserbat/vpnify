vpnify
==

This tool can be used to transparently route traffic of certain programs through VPN, while keeping the rest of it routed normally. It is protocol-agnostic and can work with any VPN software.

For example:

    vpnify sudo openvpn --config vpn.conf

Creates an isolated VPN connection. To make a program use this connection, you can use

    vpnify <program>

That's all. No configuration needed. It creates network namespace and configures it on the first run and deletes it once the last process using it exits.

Installation
--

Just copy to /usr/local/bin/

    sudo cp $HOME/vpnify/vpnify /usr/local/bin/vpnify

Multiple VPN's
--
To create two or more distinct VPN connections, you just need to create a new symlink.

    ln -s /usr/local/bin/vpnify /usr/local/bin/vpnify2

Now you can do this:

    vpnify sudo openvpn --config vpn.conf
    vpnify2 sudo openvpn --config vpn2.conf

Programs run with vpnify2 will use different connection from programs run with vpnify.

Custom resolv.conf and hosts
--

You can put your custom hosts and resolv.conf file to /etc/vpnify/ (or /etc/vpnify/\<name\> for a symlinked version). 

Also you can create folders named "pre.d" and "post.d" in the same folder with custom hooks that will be executed before running the supplied command inside the namespace and after the cleanup respectively.

Advanced features: Limiting clearnet access
--
You can use hooks to limit clearnet access by the applications run inside vpnify. First let's create a folder /etc/vpnify/pre.d/:

    mkdir -p /etc/vpnify/pre.d/

Or, if you want to setup a symlinked version,

    mkdir -p /etc/vpnify/<symlink-name>/pre.d/

Now we need to create a hook that will execute firewall commands:

    vim /etc/vpnify/pre.d/limit.sh

Contents of this file can be something like:

    iptables -I FORWARD -i $VETH0 -j DROP # Drop all outgoing traffic
    iptables -I FORWARD -i $VETH0 -d 198.51.100.157 -p udp --destination-port 1024 -j ACCEPT # Allow ONLY packets going to your VPN server

Where 198.51.100.157 is IP address of your VPN server. Replace udp/1024 with transport protocol your VPN uses it's port.
This forbids all outgoing traffic from inside vpnify except for traffic going to 198.51.100.157 udp:1024.

Don't forget to make the hook executable!

    chmod +x /etc/vpnify/pre.d/limit.sh


Take a look at files in example-hooks/\*.d/limit.sh for a better explanation and a clean-up hook!

unVpnify
---
You can use this script to route all the traffic on your machine through a VPN *except* for applications running inside (un)vpnify!

To do this, let's create a symlink:

    ln -s /usr/local/bin/vpnify /usr/local/bin/unvpn

Then, we create the configuration folders

    mkdir -p /etc/vpnify/unvpnify/pre.d/
    mkdir -p /etc/vpnify/unvpnify/post.d/

And now, create a hook that does some routing magic. Look [here](https://www.thomas-krenn.com/en/wiki/Two_Default_Gateways_on_One_System) for a deeper explanation of routing commands used in this hook.

    vim /etc/vpnify/unvpnify/pre.d/unvpn.sh

    ip rule add iif $VETH0 table rt2 # Route all traffic from our namespace through a second routing table
    ip route add default via 192.168.1.1 table rt2 # Set up the default gateway on our second table

    chmod +x /etc/vpnify/unvpnify/unvpn.sh

Also we need to add the 'rt2' routing table to our system:

    echo '1 rt2' >> /etc/iproute2/rt_tables

Check out example-hooks/\*.d/unvpn.sh for more information and a clean-up hook.

Compatibility
--

This script should work on any modern linux that supports network and mount namespaces and has nsenter command available. I have tested it on Void Linux, Ubuntu 16.04, CentOS 6.5 and 7.
