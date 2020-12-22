# RK3308 buildroot system

It seems that there is no simple RK3308 buildroot system.
This repo generates a bottable sdcard image for the RK3308 platform.

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
git clone git@github.com:flatmax/buildroot.rk3308.git buildroot.rk3308
```

# To make the system

```
source buildroot.rk3308/setup.RockPiS.sh yourPath/buildroot
```

# ensure you have your buildroot net downloads directory setup

```
mkdir yourPath/buildroot.dl
```

# build the system

```
make
```

# installing

Insert your sdcard into your drive and make sure it isn't mounted. Write the image to the disk.

NOTE: The following command will overwrite any disk attached to /dev/sdg
NOTE: Be super careful here!

```
OF=/dev/sdf; rootDrive=`mount | grep ' / ' | grep $OF`; if [ -z $rootDrive ]; then sudo umount $OF[123456789]; sudo dd if=output/images/sdcard.img of=$OF; else echo you are trying to overwrite your root drive; fi
```

# using

ssh in as user root, no pass. Or connect to the console debug uart with a serial cable.
