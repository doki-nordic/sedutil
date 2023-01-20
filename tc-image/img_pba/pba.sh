#!/bin/sh

sudo linuxpba /home/tc/devs.txt
sudo chmod 666 /home/tc/devs.txt

/my/tcz/tcz-install.sh

cat /home/tc/devs.txt
