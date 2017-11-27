#!/bin/bash

# LOGGING=true

# Packets from ${SRC} will be routed into the OpenVPN pipe using DNAT.
SRC="10.2.0.100/24"
# ${DST} is the destination IP in the OpenVPN tunnel
DST="10.8.0.1"

IPT=/sbin/iptables

# Need to enable ip forwarding. (Can be set permanently in /etc/sysctl.conf.)
echo 1 > /proc/sys/net/ipv4/ip_forward

# Set default policy to accept
$IPT -P OUTPUT ACCEPT
$IPT -P INPUT ACCEPT
$IPT -P FORWARD DROP
# Flush/delete all rules
$IPT -t nat -F
$IPT -t mangle -F
$IPT -F
$IPT -X

# Use DNAT to reroute packetsfrom ${SRC} to ${DST}
$IPT -t nat -A PREROUTING -s ${SRC} -j DNAT --to-destination ${DST}
# Enable NAT (i.e., modify packets so they look like they originated from this node).
$IPT -t nat -A POSTROUTING -j MASQUERADE

$IPT -A FORWARD -s ${DST} -d ${SRC} -j ACCEPT
$IPT -A FORWARD -s ${SRC} -d ${DST} -j ACCEPT

if [ $LOGGING ]; then
	$IPT -A INPUT -s ${REDIRECT_SRC}   -j LOG --log-prefix "iptables-INPUT: " --log-level 4
	$IPT -A FORWARD -s ${REDIRECT_SRC} -j LOG --log-prefix "iptables-FORWARD: " --log-level 4
	$IPT -A OUTPUT -s ${REDIRECT_SRC}  -j LOG --log-prefix "iptables-OUTPUT: " --log-level 4
	$IPT -t nat -A PREROUTING          -j LOG --log-prefix "iptables-nat-PREROUTING: " --log-level 4
	$IPT -t nat -A POSTROUTING         -j LOG --log-prefix "iptables-nat-POSTROUTING: " --log-level 4
	$IPT -t nat -A INPUT               -j LOG --log-prefix "iptables-nat-INPUT: " --log-level 4
	$IPT -t nat -A OUTPUT              -j LOG --log-prefix "iptables-nat-OUTPUT: " --log-level 4
fi
