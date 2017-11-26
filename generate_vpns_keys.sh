#!/bin/bash

# ---------------------------
# run in the ca
# ---------------------------

cd ~/openvpn-ca

source vars

./clean-all

./build-key-server server

# strong DH-keys to use during key exchange
./build-dh


