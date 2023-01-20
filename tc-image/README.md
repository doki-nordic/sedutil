# TinyCore-based bootable images

Required:
* Ubuntu (tested with 22.04)
* VirualBox (tested with 7.0)
* `root` access
* Internet connection (both host and VM)
* `p7zip-full`, `syslinux` and `syslinux-efi` Ubuntu packages:
   ```
   sudo apt-get install p7zip-full syslinux syslinux-efi
   ```

Build instructions:
1. Run `./create1.sh` to create TinyCore image capable of building `sedutil-cli` and `linuxpba` from sources.
1. Create and run a VM with `data/img_build.vmdk` as its main hard disk and enable EFI boot.
   * If TinyCore was not booted automatically, exit EFI shell (`exit` command) and manually select `/EFI/BOOT/BOOTX64.EFI` file.
1. On VM run `/my/build.sh`.
1. Power off VM with `sudo poweroff`.
1. Run `./create2.sh` to create final image.
1. The final image is at `data/img_pba.img`.

You can create a USB stick with `sudo ./make_disk.sh /dev/[your_USB_dev]`.
