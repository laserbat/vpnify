# Try to find a second routing table
TABLE=$(egrep '^1\s+\w+' /etc/iproute2/rt_tables | sed -E 's/1\s+//g')

# Drop the routing rule 
ip rule del iif $VETH0 table rt2

# Flush routes 
ip route flush table rt2 
