#!/bin/bash

# LOGGING=true

CLIENT_CONFIGS=.

IPT=/sbin/iptables
# Uncomment to do "dry-run"
# IPT=/bin/echo

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

$IPT -t nat -A POSTROUTING -j MASQUERADE

# Load all client specific forward rules
for file in "${CLIENT_CONFIGS}/*.iptables"; do
	source $file;
done


if [ $LOGGING ]; then
	$IPT -A INPUT -s ${REDIRECT_SRC}   -j LOG --log-prefix "iptables-INPUT: " --log-level 4
	$IPT -A FORWARD -s ${REDIRECT_SRC} -j LOG --log-prefix "iptables-FORWARD: " --log-level 4
	$IPT -A OUTPUT -s ${REDIRECT_SRC}  -j LOG --log-prefix "iptables-OUTPUT: " --log-level 4
	$IPT -t nat -A PREROUTING          -j LOG --log-prefix "iptables-nat-PREROUTING: " --log-level 4
	$IPT -t nat -A POSTROUTING         -j LOG --log-prefix "iptables-nat-POSTROUTING: " --log-level 4
	$IPT -t nat -A INPUT               -j LOG --log-prefix "iptables-nat-INPUT: " --log-level 4
	$IPT -t nat -A OUTPUT              -j LOG --log-prefix "iptables-nat-OUTPUT: " --log-level 4
fi
