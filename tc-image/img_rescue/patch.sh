#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

$SCRIPT_DIR/../img_pba/patch.sh

H Copy PBA image...
mkdir -p root/usr/sedutil
cp ../img_pba.img root/usr/sedutil/
sudo chown root:root root/usr/sedutil/img_pba.img
sudo chmod 644 root/usr/sedutil/img_pba.img
