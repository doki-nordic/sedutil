#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

H Copying scripts...
cp $SCRIPT_DIR/../data/sedutil-cli root/sbin/
cp $SCRIPT_DIR/../data/linuxpba root/sbin/

H Changing owner...
sudo chown root:root root/sbin/sedutil-cli
sudo chown root:root root/sbin/linuxpba
sudo chmod 777 root/sbin/sedutil-cli
sudo chmod 777 root/sbin/linuxpba

H Adding linuxpba to startup
#sudo cp $SCRIPT_DIR/pba.sh root/etc/profile.d/
#sudo chown root:root root/etc/profile.d/pba.sh
#sudo chmod 777 root/etc/profile.d/pba.sh

mkdir -p root/my
echo chown tc:staff /my/.profile >> root/opt/bootsync.sh
echo cp /my/.profile /home/tc/ >> root/opt/bootsync.sh
cp $SCRIPT_DIR/pba.sh root/my/.profile
