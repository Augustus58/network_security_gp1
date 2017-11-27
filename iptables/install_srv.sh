#!/bin/bash

SRC_DIR=srvr
SCRIPT_NAME=ns-fw.start.sh
# SRC_SERVICE=ns-fw.service
SRC_SCRIPT=${SRC_DIR}/${SCRIPT_NAME}

DST_SCRIPT=/etc/ns-fw
# DST_SERVICE=/etc/systemd/system

CLIENT_DIR=${DST_SCRIPT}/clients

if [ ! -e ${DST_SCRIPT} ]; then
	mkdir -p ${DST_SCRIPT}
fi

if [ ! -e ${CLIENT_DIR} ]; then
	mkdir -p ${CLIENT_DIR}
fi

# copy in configs
# echo "${SRC_SERVICE} -> ${DST_SERVICE}"
# cp ${SRC_SERVICE} ${DST_SERVICE}
echo "${SRC_SCRIPT} -> ${DST_SCRIPT}"
cp ${SRC_SCRIPT} ${DST_SCRIPT}

# edit main script
sed -i "s|^CLIENT_CONFIGS=.*|CLIENT_CONFIGS=${CLIENT_DIR}|" ${DST_SCRIPT}/${SCRIPT_NAME}
