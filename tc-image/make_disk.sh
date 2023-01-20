#!/bin/bash
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

H Copying raw image...
dd if=data/img_pba.img of=$1 status=progress
partprobe $1
