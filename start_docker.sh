#!/bin/bash
EXTRA_SCRIPT=${EXTRA_SCRIPT:-}
CONFIG_FILE=${CONFIG_FILE:-/etc/onecache.xml}
if [[ -f "$EXTRA_SCRIPT" ]]; then
	$EXTRA_SCRIPT
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
	echo "Config File not Found >> Opening Shell for Operation"
	bash
fi

/usr/bin/onecache $CONFIG_FILE
