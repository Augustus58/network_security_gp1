#!/bin/bash

# ---------------------------
# Run in the vpns
#
# Files ca.crt , [client].crt , [client].key,
# and ta.key should be in the ~/vpn-keys folder
#
# First argument: client
# Second argument: client  IP
# ---------------------------

if [[ ! -f ~/vpn-keys/ca.crt ]] ; then
    echo 'File "ca.crt" is not available, aborting.'
    exit
fi

if [[ ! -f "~/vpn-keys/""$1"".crt" ]] ; then
    echo 'File "'"$1"'.crt" is not available, aborting.'
    exit
fi

if [[ ! -f "~/vpn-keys/""$1"".key" ]] ; then
    echo 'File "'"$1"'.key" is not available, aborting.'
    exit
fi

if [[ ! -f ~/vpn-keys/ta.key ]] ; then
    echo 'File "ta.key" is not available, aborting.'
    exit
fi

KEY_DIR=~/vpn-keys
OUTPUT_DIR=~/client-configs/files
BASE_CONFIG=~/client-configs/base.conf

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${1}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ${KEY_DIR}/ta.key \
    <(echo -e '</tls-auth>') \
    > ${OUTPUT_DIR}/${1}.ovpn

# ---------------------------
# iptables rules
# ---------------------------
