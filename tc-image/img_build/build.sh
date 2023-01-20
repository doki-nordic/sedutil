#!/bin/sh
SCRIPT_FILE=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_FILE")
tce-load -wi bash.tcz
$SCRIPT_DIR/build2.sh
