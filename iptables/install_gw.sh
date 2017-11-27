#!/bin/bash

# SRC_SERVICE=gw/ns-fw.service
SRC_SCRIPT=gw/ns-fw.start.sh

DST_SCRIPT=/etc/ns-fw
# DST_SERVICE=/etc/systemd/sytem

if [ ! -e ${DST_SCRIPT} ]; then
	mkdir -p ${DST_SCRIPT}
fi
# cp ${SRC_SERVICE} ${DST_SERVICE}
cp ${SRC_SCRIPT} ${DST_SCRIPT}
