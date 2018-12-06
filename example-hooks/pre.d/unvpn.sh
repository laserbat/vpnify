# Try to find a second routing table
TABLE=$(egrep '^1\s+\w+' /etc/iproute2/rt_tables | sed -E 's/1\s+//g')

# Create it if it doesn't exist
if [[ -z "$TABLE" ]]; then
	TABLE=rt2
	echo '1 rt2' >> /etc/iproute2/rt_tables
fi

# Use it for traffic coming out of our namespace
ip rule add iif $VETH0 table rt2

# Replace this with appropriate default gateway
ip route add default via 192.168.1.1 table rt2
