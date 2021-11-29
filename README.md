# RK3308, RK3328, RK3566 buildroot system

Now builds for rk3308, rk3328 and RK3566

This repo generates a bootable sdcard image for the RK3xxx platform.
It is a 64 bit image. Based on buildroot, this directory is an external buildroot tree - it integrates into the main buildroot tree seamlessly.

For the RK3399 buildroot images, have a look at this dedicated repo : https://github.com/flatmax/buildroot.rk3399.external

RK3566 requires a little more work on the boot loader.

# Initial setup

Clone buildroot. For example :

```
cd yourPath
git clone git://git.busybox.net/buildroot buildroot
```

Make sure you have requirements :
```
sudo apt-get install -y build-essential gcc g++ autoconf automake libtool bison flex gettext
sudo apt-get install -y patch texinfo wget git gawk curl lzma bc quilt
```

Clone the external buildroot tree :
```
git clone git@github.com:flatmax/buildroot.rockchip.git buildroot.rockchip.ext
```

# To make the system

```
# For the RockPi S
source buildroot.rockchip.ext/setup.rockPiS.sh yourPath/buildroot
# For the RockPi E (rk3328 based board)
source buildroot.rockchip.ext/setup.rockPiE.sh yourPath/buildroot
# For the Pine64 Quartz64 (rk3566 based board)
source buildroot.rockchip.ext/setup.quartz64.sh yourPath/buildroot
```

# build the system

```
make
```

# installing

Insert your sdcard into your drive and make sure it isn't mounted. Write the image to the disk.

NOTE: The following command will overwrite any disk attached to $OF. Don't overwrite your root.

```
OF=/dev/sdf; rootDrive=`mount | grep " / " | grep $OF`; if [ -z $rootDrive ]; then sudo umount $OF[123456789]; sudo dd if=output/images/sdcard.img of=$OF; else echo you are trying to overwrite your root drive; fi
```

# using

Connect to the console debug uart with a serial cable. Or, add the openssh-server pacakge to the buildsystem, then ssh in as user root, no pass.

# TODO
Try to find suitable rock-chip boot binaries on github. rk3308_ddr_589MHz_uart0_m0_v1.26.bin can't be found in rkbin.
Shift uboot and the kernel to mainline Linux.
