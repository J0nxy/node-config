#!/bin/sh

# Script zum Aendern der IP-Adressen und Bereiche
# Alle Adressen und Bereiche werden konsistent geaendert

# Konfiguration abfragen
echo "IPv4 Adresse des Nodes - z.B. 10.159.64.1"
read ipv4_addr
echo ""
echo "IPv6-ULA-Netz des Nodes (CIDR) - z.B. fdd3:5d16:b5dd:f040::/64"
read ipv6_network

#Basis-Adressen fuer die entspr. Routes ausrechnen
ipv4_network=$(owipcalc $ipv4_addr/24 network)
ipv6_addr=$(owipcalc $ipv6_network add 1 prefix 128)


# Konfiguration setzen
uci -q batch <<EOF
	set network.freifunk.ipaddr='$ipv4_addr'
	set network.freifunk.ip6addr='$ipv6_addr'
	set network.route4_node_subnet.target='$ipv4_network'
	set network.fastd.ipaddr='$ipv4_addr'
	set network.babel_mesh.ipaddr='$ipv4_addr'
	set network.babel_mesh5.ipaddr='$ipv4_addr'

        set network.freifunk.ip6prefix='$ipv6_network'
	set network.route_6_node_subnet.target='$ipv6_network'
	set network.rule_node_ip_high_prio.src='$ipv4_addr/32'

	set network.freifunk.disabled='0'
	set network.fastd.disabled='0'
	set network.babel_mesh.disabled='0'
	set network.babel_mesh5.disabled='0'

	commit network
EOF

