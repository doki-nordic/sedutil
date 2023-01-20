#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }


if [ "$1" != "reuse" ]; then

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

fi

H Prepare PBA image...
mkdir -p $SCRIPT_DIR/data/img_pba
cd $SCRIPT_DIR/data/img_pba
sudo $SCRIPT_DIR/_make_tc_img.sh `id -un`:`id -gn` $SCRIPT_DIR/downloads/CorePure64-current.iso 65536 ../img_pba.img $SCRIPT_DIR/img_pba/patch.sh  ; cd ..

H Prepare RESCUE image...
mkdir -p $SCRIPT_DIR/data/img_rescue
cd $SCRIPT_DIR/data/img_rescue
sudo $SCRIPT_DIR/_make_tc_img.sh `id -un`:`id -gn` $SCRIPT_DIR/downloads/CorePure64-current.iso 262144 ../img_rescue.img $SCRIPT_DIR/img_rescue/patch.sh  ; cd ..
