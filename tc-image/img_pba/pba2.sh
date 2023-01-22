#!/bin/bash

qjs /my/start.js /home/tc/devs.txt /home/tc/parts.txt

script_file='pba-startup-script.sh'
maxdepth=2

while read p; do
    find $p -maxdepth $maxdepth -iname $script_file -exec {} \;
done </home/tc/parts.txt
