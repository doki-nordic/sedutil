#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

H Copying scripts...
mkdir -p root/my
cp $SCRIPT_DIR/../data/sedutil-cli root/sbin/
cp $SCRIPT_DIR/../data/linuxpba root/sbin/
cp $SCRIPT_DIR/../data/qjs root/sbin/
cp $SCRIPT_DIR/start.js root/my/
cp $SCRIPT_DIR/pba2.sh root/my/

H Changing owner...
sudo chown root:root root/sbin/sedutil-cli
sudo chown root:root root/sbin/linuxpba
sudo chown root:root root/sbin/qjs
sudo chown root:root root/my/start.js
sudo chown root:root root/my/pba2.sh
sudo chmod 777 root/sbin/sedutil-cli
sudo chmod 777 root/sbin/linuxpba
sudo chmod 777 root/sbin/qjs
sudo chmod 777 root/my/pba2.sh

H Adding linuxpba to startup
mkdir -p root/my
echo chown tc:staff /my/.profile >> root/opt/bootsync.sh
echo cp /my/.profile /home/tc/ >> root/opt/bootsync.sh
cp $SCRIPT_DIR/pba.sh root/my/.profile

H Copy TCZ files...
mkdir -p root/my/tcz
cp $SCRIPT_DIR/../downloads/pba/*.tcz $SCRIPT_DIR/../downloads/pba/*.sh root/my/tcz/
