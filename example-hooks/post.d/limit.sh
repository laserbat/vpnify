# Clean up our rules
iptables -D FORWARD -i $VETH0 -j DROP
iptables -D FORWARD -i $VETH0 -d 198.51.100.157 -p udp --destination-port 1024 -j ACCEPT
