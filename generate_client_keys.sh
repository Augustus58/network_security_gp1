#!/bin/bash

# ---------------------------
# run in the ca
# ---------------------------

CLIENT=$1

cd ~/openvpn-ca

source vars

./clean-all

./build-key "$CLIENT"

