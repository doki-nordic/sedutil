#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
function H() { echo -e "\033[0;32m$*\033[0m"; }

uid=$1
iso=`realpath $2`
sectors=$3
image=$4

H Recreating directories...
rm -Rf iso || true
rm -Rf root || true
rm -Rf tmp || true
rm -Rf out || true
rm -f image || true
umount -q mnt || true
sleep 1
umount -q -f mnt || true
rmdir mnt || true
mkdir -p iso
mkdir -p root
mkdir -p tmp
mkdir -p out/boot/syslinux
mkdir -p out/EFI/BOOT
mkdir -p mnt

H Unpacking TinyCode ISO...
rm -Rf iso
mkdir -p iso
cd iso
7z x $iso  # If needed, install 7z with: sudo apt-get install p7zip-full
cd ..

H Unpacking TinyCode...
rm -Rf root
mkdir -p root
cd root
gunzip -c ../iso/boot/corepure64.gz | cpio -id
cd ..

H Patching files...
${@:5}

H Packing...
cd root
find . | cpio -oH newc | gzip -9 > ../out/boot/syslinux/corepure64.gz
# better, but slower:
#find . -print -depth | cpio -oH newc | 7z a -tgzip -mx=9 -mpass=20 -mmt=off -si ../out/boot/syslinux/corepure64.gz
cd ..

H Validating...
gunzip -c iso/boot/corepure64.gz | cpio -t | sort > tmp/list-in.txt
gunzip -c out/boot/syslinux/corepure64.gz | cpio -t | sort > tmp/list-out.txt

H Copying Linux...
cp iso/boot/vmlinuz64 out/boot/syslinux/

H Copy syslinux files...
cp /usr/lib/SYSLINUX.EFI/efi64/syslinux.efi out/EFI/BOOT/BOOTX64.EFI   # If needed, install "syslinux" and "syslinux-efi" packages
cp /usr/lib/syslinux/modules/efi64/ldlinux.e64 out/EFI/BOOT/ldlinux.e64
cp /usr/lib/SYSLINUX.EFI/efi32/syslinux.efi out/EFI/BOOT/BOOTIA32.EFI
cp /usr/lib/syslinux/modules/efi32/ldlinux.e32 out/EFI/BOOT/ldlinux.e32
cp $SCRIPT_DIR/syslinux.cfg out/boot/syslinux/

H Creating empty image...
dd if=/dev/zero of=$image bs=512 count=$sectors status=progress

H Creating virtual disk wrapper...
vmdk=`python3 $SCRIPT_DIR/util.py vmdk $image`

H Creating GPT partition table with EFI partirion...
fdisk -t gpt $image << 'EOF'
g
n






t
uefi
w
EOF
fdisk -l $image
offset_sectors=`fdisk -l -o start $image | tail -1`
size_sectors=`fdisk -l -o sectors $image | tail -1`
echo "Partition offset: $((offset_sectors*512)) bytes"
echo "Partition size:   $((size_sectors*512)) bytes"

H Formating partition image...
mkfs.fat -S 512 -n PBA --offset $offset_sectors $image $((size_sectors/2))

H Adding loop device...
dev=`udisksctl loop-setup -f $image | python3 $SCRIPT_DIR/util.py get_loop`
part=${dev}p1
echo Loop device: $part

H Mounting the partirion...
mount -t vfat $part mnt
echo Partition mount point: `realpath mnt`

H Copying to the partition...
cp -R out/* mnt/

H Unmounting the partirion and removing loop device ...
umount mnt
udisksctl loop-delete -b $dev

H Setting owner ...
chown $uid $image
chown $uid $vmdk
