# RK3308, RK3328, RK356X, RK3588 buildroot system

Now builds for rk3308, rk3328, RK3566 and RK3588

This repo generates a bootable sdcard image for the RK3xxx platform.
It is a 64 bit image. Based on buildroot, this directory is an external buildroot tree - it integrates into the main buildroot tree seamlessly.

For the RK3399 buildroot images, have a look at this dedicated repo : https://github.com/flatmax/buildroot.rk3399.external

# Initial setup

Clone buildroot. For example :

```
cd yourPath
git clone git://git.busybox.net/buildroot buildroot

# rock pi S tested with version : git checkout 2022.02.1
# rock pi 3a tested with version : git checkout 2022.05
# rock cm3 tested with version : git checkout 2022.05
# rock 5b tested with version : git checkout 2022.05
```

Make sure you have requirements :
```
sudo apt-get install -y build-essential gcc g++ autoconf automake libtool bison flex gettext
sudo apt-get install -y patch texinfo wget git gawk curl lzma bc quilt
```

If building in a minimal Docker image, you will also require :
```
sudo apt-get install -y cpio unzip rsync python3
```

***The above instructions apply to Debian-based distros.  Buildroot works on other distros, but installing the above dependencies is beyond the scope of this README; check your distro's package manager documentation.  Additionally the dash shell is required on distros where it is not the default.***

Clone the external buildroot tree :
```
git clone git@github.com:flatmax/buildroot.rockchip.git buildroot.rockchip.ext
```

# To make the system

```
# For the RockPi S
source buildroot.rockchip.ext/setup.rockPiS.sh yourPath/buildroot
# for the Radxa rock 3 a board
source buildroot.rockchip.ext/setup.rock3a.sh yourPath/buildroot
# for the Radxa rock 5b board
source buildroot.rockchip.ext/setup.rock5b.sh yourPath/buildroot
# for the Radxa rock cm3 io board
source buildroot.rockchip.ext/setup.cm3.sh yourPath/buildroot
# For the RockPi E (rk3328 based board) [needs more work]
source buildroot.rockchip.ext/setup.rockPiE.sh yourPath/buildroot
# For the Pine64 Quartz64 (rk3566 based board) [currently not working]
source buildroot.rockchip.ext/setup.quartz64.sh yourPath/buildroot
```

Make sure you have the buildroot downloads directory present (when you are in the yourPath/buildroot directory execute the following) :

```
mkdir ../buildroot.dl
```

# build the system

## Radxa rock 3 a
This board requires rkbin installed before uboot compiles
```
make rkbin
```
# Now build buildroot as per usual for all boards
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

## ssh RSA keys

To use ssh, put your id_rsa.pub into the authorized_keys in the overlays directory. This will autoload your public RSA key to the embedded system so that you can login.
```
$ mkdir -p overlays/root/.ssh; chmod go-rwx overlays/root/.ssh
$ ls -ld overlays/root/.ssh
drwx------ 2 me me 4096 Aug  3  2016 overlays/root/.ssh
$ cat ~/.ssh/id_rsa.pub > overlays/root/.ssh/authorized_keys
$ ls -l overlays/root/.ssh/authorized_keys
-rw-r--r-- 1 me me 748 Feb 24 11:17 overlays/root/.ssh/authorized_keys
```

# Rock 3 a
Uboot commands are still manual at this point. Cut and paste the contents of boot.cmd into console when uboot comes up to get linux to boot. This is working for the Radxa CM3 board and the fix is to use host mkimage rather the uboot's mkimage because of a bug there.

# TODO
## for the rk3308 board
Try to find suitable rock-chip boot binaries on github. rk3308_ddr_589MHz_uart0_m0_v1.26.bin can't be found in rkbin.
Shift uboot and the kernel to mainline Linux.
## for the rk3568 board - rock 3 a
Implement this fix for the rock 3a board
https://forum.radxa.com/t/autorun-a-uboot-script/10461/6?u=flatmax
