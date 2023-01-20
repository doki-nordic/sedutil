#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }


H Adding loop device...
cd $SCRIPT_DIR/data
dev=`udisksctl loop-setup -f img_build.img | python3 $SCRIPT_DIR/util.py get_loop`
part=${dev}p1
echo Loop device: $part

H Mounting partition...
mnt=`udisksctl mount -t vfat -b $part | python3 $SCRIPT_DIR/util.py get_mnt`
echo Mount point: $mnt

H Copying results...
cd $SCRIPT_DIR/data
cp $mnt/sedutil-cli ./
cp $mnt/linuxpba ./

H Unmounting the partirion and removing loop device ...
udisksctl unmount -b $part
udisksctl loop-delete -b $dev

H Prepare final virtual image...
mkdir -p $SCRIPT_DIR/data/img_pba
cd $SCRIPT_DIR/data/img_pba
sudo $SCRIPT_DIR/_make_tc_img.sh `id -un`:`id -gn` $SCRIPT_DIR/downloads/CorePure64-current.iso 65536 ../img_pba.img $SCRIPT_DIR/img_pba/patch.sh  ; cd ..
