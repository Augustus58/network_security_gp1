#!/bin/bash

# ---------------------------
# run in the ca
# ---------------------------

cd ~/openvpn-ca

source vars

./clean-all

./build-key "$1"

