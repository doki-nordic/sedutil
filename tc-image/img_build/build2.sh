#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

H Downloading dependecies...
#tce-load -wi git.tcz
tce-load -wi autoconf.tcz automake.tcz m4.tcz gcc.tcz gcc_base-dev.tcz glibc_add_lib.tcz make.tcz linux-5.15_api_headers.tcz glibc_base-dev.tcz

#H Checkout git repo...
#git clone https://github.com/Drive-Trust-Alliance/sedutil.git
#cd sedutil

H Coping sources...
cp -R /my/sedutil ./
cd sedutil

H Configuring...
autoreconf -i
./configure --enable-silent-rules CFLAGS="-Os -g0" CXXFLAGS="-Os -g0" LDFLAGS="-Os -g0"

H Making...
make

H Stripping...
strip --strip-debug sedutil-cli
strip --strip-unneeded sedutil-cli
strip --strip-debug linuxpba
strip --strip-unneeded linuxpba

H Mounting partition...
sudo mkdir -p /my/img
sudo mount -t vfat /dev/sda1 /my/img

H Copying results to partition...
sudo cp sedutil-cli /my/img/
sudo cp linuxpba /my/img/

H Unmounting partition...
sudo umount /my/img

H === DONE ===
echo Compialtion is done, results saved to the virtual disk.
echo Shutdown the system with:
echo
echo    sudo poweroff
echo
