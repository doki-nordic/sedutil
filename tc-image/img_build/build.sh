#!/bin/sh
SCRIPT_FILE=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_FILE")
sudo mkdir -p /my/img
sudo mount -t vfat /dev/sda1 /my/img
sudo cp -R /my/img/tcz /home/tc/
/home/tc/tcz/tcz-install.sh
$SCRIPT_DIR/_build2.sh
