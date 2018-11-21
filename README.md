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

Now we need to create a hook that will execute firewall commands:

    vim /etc/vpnify/pre.d/limit.sh

Contents of this file can be something like:

    iptables -I FORWARD -i $VETH0 -j DROP
    iptables -I FORWARD -i $VETH0 -d 198.51.100.157 -j ACCEPT

Don't forget to make the hook executable!

    chmod +x /etc/vpnify/pre.d/limit.sh

Where 198.51.100.157 is IP address of your VPN server. Forbids all outgoing traffic from inside the vpnify except for traffic going to 198.51.100.157.

Compatibility
--

Tested on Void Linux, Arch Linux, CentOS 7.5 and Ubuntu 16.04
