#!/bin/sh
/my/tcz/tcz-install.sh >/tmp/inst-res.txt 2>&1 &
echo -e "\033[0;32m"
echo 
echo 'Accept password with:'
echo ' - ENTER to search and run startup script on unlocked device.'
echo ' - ESC to reboot the system immediately after unlocking.'
echo
echo 'Use empty password to start shell.'
echo
echo -e "\033[0m"
sudo linuxpba /home/tc/devs.txt
cat /tmp/inst-res.txt
sudo /my/pba2.sh
