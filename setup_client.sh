#!/bin/bash

# ---------------------------
# Run in the client
#
# File [client].ovpn should be in the
# ~/vpn-profile folder
#
# The first argument: name of the client
# ---------------------------

if [[ ! -f "~/vpn-profile/""$1"".ovpn" ]] ; then
    echo 'File "'"$1"'.ovpn" is not available, aborting.'
    exit
fi

echo "$(whoami)"

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

apt-get install openvpn

cp -r ~/vpn-profile/. /etc/openvpn/

sed -i -e 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn

service openvpn start

# ---------------------------
# iptables rules
# ---------------------------

