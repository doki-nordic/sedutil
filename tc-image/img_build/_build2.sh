#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

H Coping sources...
cp -R /my/sedutil ./
cp -R /my/qjs ./
cd sedutil

H Configuring sedutil...
autoreconf -i
./configure --enable-silent-rules CFLAGS="-Os -g0" CXXFLAGS="-Os -g0" LDFLAGS="-Os -g0"

H Making sedutil...
make

H Stripping sedutil...
strip --strip-debug sedutil-cli
strip --strip-unneeded sedutil-cli
strip --strip-debug linuxpba
strip --strip-unneeded linuxpba

H Copying results to partition...
sudo cp sedutil-cli /my/img/
sudo cp linuxpba /my/img/

H Configuring qjs...
cd ../qjs
sed -i 's/-m32/ /g' Makefile

H Making qjs...
make qjs32_s

H Stripping qjs...
strip --strip-debug qjs32_s
strip --strip-unneeded qjs32_s

H Copying results to partition...
sudo cp qjs32_s /my/img/qjs

H Unmounting partition...
sudo umount /my/img

H === DONE ===
echo Compialtion is done, results saved to the virtual disk.
echo Shutdown the system with:
echo
echo    sudo poweroff
echo
