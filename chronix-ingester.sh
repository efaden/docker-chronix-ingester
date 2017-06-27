#!/bin/bash

# Check for config directory
if [ ! -d /data ]; then
	mkdir -p /data
fi

if [[ -z $INGESTER_LISTEN_URL ]]; then
	export INGESTER_LISTEN_URL=":$INGESTER_LISTEN_PORT"
fi

exec /usr/local/bin/chronix.ingester -checkpoint-file=/data/checkpoint.db -chronix-url=$CHRONIX_URL -listen-addr=$INGESTER_LISTEN_URL
