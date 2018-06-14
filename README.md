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
