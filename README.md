vpnify
==

This tool can be used to transparently route traffic of certain programs through VPN, while keeping the rest of it routed normally.

For example:

    vpnify sudo openvpn --config vpn.conf

Creates an isolated VPN connection. To make a program use this connection, you can use

    vpnify <program>

That's all. No configuration needed. It creates network namespace and configures it on the first run and deletes it once the last process using it exits.
