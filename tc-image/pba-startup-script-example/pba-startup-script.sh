#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

firmware_name='ubuntu'

rm -f /tmp/efi-list.txt
efibootmgr > /tmp/efi-list.txt
id=`qjs $SCRIPT_DIR/pba-startup-script/get-efi-id.js /tmp/efi-list.txt "$firmware_name"`
efibootmgr -n $id
reboot -fn
