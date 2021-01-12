#!/bin/sh

RKBIN=$BINARIES_DIR/rkbin
RKTOOLS=$RKBIN/tools
RKCHIP_LOADER=$2
RKCHIP=$2

if [ $RKCHIP = "RK3308" ]; then
  if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' ${BASE_DIR}/../.config ; then
    PLATFORM_UBOOT_IMG_SIZE="--size 512 2"
    PLATFORM_AARCH32="AARCH32"
  else
    PLATFORM_UBOOT_IMG_SIZE="--size 1024 2"
  fi
fi

# copy uboot variable file over
cp -a $BR2_EXTERNAL_RK3308_PATH/board/RK3308/vars.txt $BINARIES_DIR/

# copy overlays over
linuxDir=`find $BASE_DIR/build -name 'vmlinux' -type f | xargs dirname`
rm -rf $BINARIES_DIR/rockchip/overlays
mkdir -p $BINARIES_DIR/rockchip/overlays
cp -a ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay/*.dtbo $BINARIES_DIR/rockchip/overlays

ubootName=`find $BASE_DIR/build -name 'uboot-*' -type d`
boardDir=`dirname $_`

# uboot creation
$RKTOOLS/loaderimage --pack --uboot $ubootName/u-boot-dtb.bin $BINARIES_DIR/uboot.img 0x600000 --size 1024 1

# trust img creation
cat >$ubootName/trust.ini <<EOF
[VERSION]
MAJOR=1
MINOR=0
[BL30_OPTION]
SEC=0
[BL31_OPTION]
SEC=1
PATH=$BR2_EXTERNAL_RK3308_PATH/board/RK3308/rk3308_bl31_v2.10.elf
ADDR=0x00010000
[BL32_OPTION]
SEC=0
[BL33_OPTION]
SEC=0
[OUTPUT]
PATH=$BINARIES_DIR/trust.img
EOF
$RKBIN/tools/trust_merger --size 1024 1 ${ubootName}/trust.ini

# first stage boot loader creation
$ubootName/tools/mkimage -n rk3308 -T rksd -d $boardDir/rk3308_ddr_589MHz_uart0_m0_v1.26.bin $BINARIES_DIR/idbloader.img
cat $boardDir/rk3308_miniloader_emmc_port_support_sd_20190717.bin >> $BINARIES_DIR/idbloader.img

# Generate the uboot script
$ubootName/tools/mkimage -C none -A arm -T script -d $BR2_EXTERNAL_RK3308_PATH/board/RK3308/boot.cmd $BINARIES_DIR/boot.scr

# Put the device trees into the correct location
mkdir -p $BINARIES_DIR/rockchip; cp -a $BINARIES_DIR/*.dtb $BINARIES_DIR/rockchip
$BASE_DIR/../support/scripts/genimage.sh -c $BR2_EXTERNAL_RK3308_PATH/board/RK3308/genimage.cfg

echo
echo
echo compilation done
echo
echo
echo
echo write your image to the sdcard, don\'t forget to change OF=/dev/sdf to your sdcard drive ...
echo use the following command ...
echo
echo 'OF=/dev/sdf; rootDrive=`mount | grep " / " | grep $OF`; if [ -z $rootDrive ]; then sudo umount $OF[123456789]; sudo dd if=output/images/sdcard.img of=$OF; else echo you are trying to overwrite your root drive; fi'
echo
echo


# lrwxrwxrwx  1 flatmax flatmax        63 Dec 24 12:23 rk3308_loader_v1.30.119.bin -> /home/flatmax.unencrypted/rockchip-bsp/out/u-boot/idbloader.img
# lrwxrwxrwx  1 flatmax flatmax        59 Dec 24 12:24 trust.img -> /home/flatmax.unencrypted/rockchip-bsp/out/u-boot/trust.img
# lrwxrwxrwx  1 flatmax flatmax        59 Dec 24 12:24 u-boot.img -> /home/flatmax.unencrypted/rockchip-bsp/out/u-boot/uboot.img
