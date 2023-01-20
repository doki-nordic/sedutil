#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

H Removing old data...
cd $SCRIPT_DIR
sudo rm -Rf data

H Downloading TinyCode if needed...
mkdir -p $SCRIPT_DIR/downloads
cd $SCRIPT_DIR/downloads
[ -f CorePure64-current.iso ] || wget http://tinycorelinux.net/13.x/x86_64/release/CorePure64-current.iso
[ -f TinyCorePure64-current.iso ] || wget http://tinycorelinux.net/13.x/x86_64/release/TinyCorePure64-current.iso

H Prepare virtual image for sedutil compilation...
mkdir -p $SCRIPT_DIR/data/img_build
cd $SCRIPT_DIR/data/img_build
sudo $SCRIPT_DIR/_make_tc_img.sh `id -un`:`id -gn` $SCRIPT_DIR/downloads/TinyCorePure64-current.iso 524288 ../img_build.img $SCRIPT_DIR/img_build/patch.sh  ; cd ..

H Switch to VM
echo Virtual disk for sedutil-cli tool is prepared at `realpath $SCRIPT_DIR/data/img_build.img`
echo Start VM with this disk and compile the tool with shell script located at:
echo    /my/build.sh
echo
echo After successfull compilation, get back here and start:
echo    $SCRIPT_DIR/create2.sh
echo
