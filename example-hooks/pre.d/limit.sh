# Drop all outgoing traffic from our namespace
iptables -I FORWARD -i $VETH0 -j DROP
# Expect for traffic going to your VPN server
# Replace 198.51.100.157 with the correct ip
# And tcp/1024 with your VPN transport protocol and port
iptables -I FORWARD -i $VETH0 -d 198.51.100.157 -p udp --destination-port 1024 -j ACCEPT
