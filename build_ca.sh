#!/bin/bash

# ---------------------------
# run in the ca
# ---------------------------

echo "$(whoami)"

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

apt-get install easy-rsa

make-cadir ~/openvpn-ca

cd ~/openvpn-ca

source vars

./clean-all

# build ca certificate/key
./build-ca
