#!/bin/bash

BASE_SCRIPT=srvr/client.iptables

CLIENT_DIR=/etc/ns-fw/clients
FILE_EXT=.iptables

SRC=$1
DST=$2

if [[ ! $SRC =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	echo "source '$SRC' not a valid IP"
	exit
fi

if [[ ! $DST =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	echo "destination '$DST' not a valid IP"
	exit
fi


NEW_FILE=${CLIENT_DIR}/${SRC}-${DST}.iptables
echo "Creating ${NEW_FILE}"

# copy in configs
cp ${BASE_SCRIPT} ${NEW_FILE}

echo "Updating ${NEW_FILE}"
sed -i s/^SRC=.*/SRC=${SRC}/ ${NEW_FILE}
sed -i s/^DST=.*/DST=${DST}/ ${NEW_FILE}
