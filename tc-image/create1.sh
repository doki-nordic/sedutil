#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

if [ "$1" = "reuse" ]; then
    mv data/sedutil-cli $SCRIPT_DIR/downloads
    mv data/linuxpba $SCRIPT_DIR/downloads
    mv data/qjs $SCRIPT_DIR/downloads
fi

H Removing old data...
cd $SCRIPT_DIR
sudo rm -Rf data

if [ "$1" = "reuse" ]; then
    mkdir -p data
    mv $SCRIPT_DIR/downloads/sedutil-cli data/
    mv $SCRIPT_DIR/downloads/linuxpba data/
    mv $SCRIPT_DIR/downloads/qjs data/
fi

H Downloading TinyCode if needed...
mkdir -p $SCRIPT_DIR/downloads
cd $SCRIPT_DIR/downloads
[ -f CorePure64-current.iso ]     || wget http://tinycorelinux.net/13.x/x86_64/release/CorePure64-current.iso
[ -f TinyCorePure64-current.iso ] || wget http://tinycorelinux.net/13.x/x86_64/release/TinyCorePure64-current.iso

H Downloading TinyCode TCZ files for PBA if needed...
rm -f pba/*.done
cp $SCRIPT_DIR/tcz-install.sh pba/
$SCRIPT_DIR/_download_tcz.sh pba bash.tcz
$SCRIPT_DIR/_download_tcz.sh pba efibootmgr.tcz
$SCRIPT_DIR/_download_tcz.sh pba parted.tcz

H Downloading TinyCode TCZ files for build image if needed...
rm -f build/*.done
cp $SCRIPT_DIR/tcz-install.sh build/
$SCRIPT_DIR/_download_tcz.sh build git.tcz
$SCRIPT_DIR/_download_tcz.sh build bash.tcz
$SCRIPT_DIR/_download_tcz.sh build autoconf.tcz
$SCRIPT_DIR/_download_tcz.sh build automake.tcz
$SCRIPT_DIR/_download_tcz.sh build m4.tcz
$SCRIPT_DIR/_download_tcz.sh build gcc.tcz
$SCRIPT_DIR/_download_tcz.sh build gcc_base-dev.tcz
$SCRIPT_DIR/_download_tcz.sh build glibc_add_lib.tcz
$SCRIPT_DIR/_download_tcz.sh build make.tcz
$SCRIPT_DIR/_download_tcz.sh build linux-5.15_api_headers.tcz
$SCRIPT_DIR/_download_tcz.sh build glibc_base-dev.tcz
$SCRIPT_DIR/_download_tcz.sh build sed.tcz

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
