#!/bin/bash

partprobe

echo ====== List of unlocked devices ======
cat /home/tc/devs.txt 2> /dev/null
echo ======================================

mkdir -p /my/mnt
qjs /my/start.js /home/tc/devs.txt /home/tc/parts.txt /my/mnt

echo ====== List of partitions on those devices ======
cat /home/tc/parts.txt
echo =================================================

script_file='pba-startup-script.sh'
maxdepth=2

while read p; do
    find $p -maxdepth $maxdepth -iname $script_file -exec {} \;
done </home/tc/parts.txt

echo sudo bash >> /home/tc/.ash_history
