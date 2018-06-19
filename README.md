vpnify
==

This tool can be used to transparently route traffic of certain programs through VPN, while keeping the rest of it routed normally.

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

Also you can create folders named "pre.d" and "post.d" with custom hooks that will be executed before running the supplied command inside the namespace and after the cleanup respectively.

Compatibility
--

Tested on Void Linux, Arch Linux, CentOS 7.5 and Ubuntu 16.04
