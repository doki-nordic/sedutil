#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

H Copying scripts...
cp $SCRIPT_DIR/../data/sedutil-cli root/sbin/
cp $SCRIPT_DIR/../data/linuxpba root/sbin/

H Copy PBA image...
mkdir -p root/usr/sedutil
cp ../img_pba.img root/usr/sedutil/

H Changing owner...
sudo chown root:root root/sbin/sedutil-cli
sudo chown root:root root/sbin/linuxpba
sudo chown root:root root/usr/sedutil/img_pba.img
sudo chmod 777 root/sbin/sedutil-cli
sudo chmod 777 root/sbin/linuxpba
sudo chmod 644 root/usr/sedutil/img_pba.img
