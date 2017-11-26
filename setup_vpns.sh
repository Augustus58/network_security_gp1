#!/bin/bash

# ---------------------------
# Run in the vpns
#
# Files ca.crt , server.crt , server.key , and dh2048.pem
# should be in the ~/vpn-keys folder
#
# The first argument: the IP address of the VPN server
# ---------------------------

if [[ ! -f ~/vpn-keys/ca.crt ]] ; then
    echo 'File "ca.crt" is not available, aborting.'
    exit
fi

if [[ ! -f ~/vpn-keys/server.crt ]] ; then
    echo 'File "server.crt" is not available, aborting.'
    exit
fi

if [[ ! -f ~/vpn-keys/server.key ]] ; then
    echo 'File "server.key" is not available, aborting.'
    exit
fi

if [[ ! -f ~/vpn-keys/dh2048.pem ]] ; then
    echo 'File "dh2048.pem" is not available, aborting.'
    exit
fi

echo "$(whoami)"

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

apt-get install openvpn

openvpn --genkey --secret /etc/openvpn

cp ca.crt server.crt server.key dh2048.pem /etc/openvpn

gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz | sudo tee /etc/openvpn/server.conf

sed -i -e 's/;tls-auth ta.key 0/tls-auth ta.key 0/g' /etc/openvpn/server.conf

sed -i '/tls-auth ta.key 0/a key-direction 0' /etc/openvpn/server.conf

sed -i -e 's/;cipher AES-128-CBC/cipher AES-128-CBC/g' /etc/openvpn/server.conf

sed -i '/cipher AES-128-CBC/auth SHA256' /etc/openvpn/server.conf

sed -i -e 's/;user nobody/user nobody/g' /etc/openvpn/server.conf

sed -i -e 's/;group nogroup/group nogroup/g' /etc/openvpn/server.conf

sed -i -e 's/;proto tcp/proto tcp/g' /etc/openvpn/server.conf

sed -i -e 's/proto udp/;proto udp/g' /etc/openvpn/server.conf

# allow IP forwarding
sed -i -e 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

systemctl start openvpn@server

systemctl enable openvpn@server

mkdir -p ~/client-configs/files

chmod 700 ~/client-configs/files

# ---------------------------
# client base config
# ---------------------------

cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf ~/client-configs/base.conf

sed -i -e 's/;proto tcp/proto tcp/g' ~/client-configs/base.conf

sed -i -e 's/proto udp/;proto udp/g' ~/client-configs/base.conf

sed -i -e 's/remote my-server-1 1194/'"$1"' 1194/g' ~/client-configs/base.conf

sed -i -e 's/;user nobody/user nobody/g' ~/client-configs/base.conf

sed -i -e 's/;group nogroup/group nogroup/g' ~/client-configs/base.conf

sed -i -e 's/ca ca.crt/#ca ca.crt/g' ~/client-configs/base.conf

sed -i -e 's/cert client.crt/#cert client.crt/g' ~/client-configs/base.conf

sed -i -e 's/key client.key/#key client.key/g' ~/client-configs/base.conf

sed -i -e 's/;cipher x/cipher AES-128-CBC/g' ~/client-configs/base.conf

sed -i '/cipher AES-128-CBC/auth SHA256' ~/client-configs/base.conf

sed -i '/;tls-auth ta.key 1/a key-direction 1' ~/client-configs/base.conf

echo "script-security 2" >> ~/client-configs/base.conf
echo "echo "script-security 2" >> ~/client-configs/base.conf" >> ~/client-configs/base.conf
echo "echo "script-security 2" >> ~/client-configs/base.conf" >> ~/client-configs/base.conf

# ---------------------------
# iptables rules
# ---------------------------
