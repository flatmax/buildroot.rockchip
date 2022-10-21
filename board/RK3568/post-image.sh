#!/bin/dash

RKBIN=$BINARIES_DIR/rkbin
RKCHIP_LOADER=$2
RKCHIP=$2

# copy uboot variable file over
cp -a $BR2_EXTERNAL_RK3308_PATH/board/RK3568/vars.txt $BINARIES_DIR/

# copy overlays over
linuxDir=`find $BASE_DIR/build -name 'vmlinux' -type f | xargs dirname`
mkdir -p $BINARIES_DIR/rockchip/overlays
if [ -d ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay ]; then
  cp -a ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay/*.dtbo $BINARIES_DIR/rockchip/overlays
fi

ubootName=`find $BASE_DIR/build -name 'uboot-*' -type d`
boardDir=`dirname $_`

echo creating uboot.img
currentDir=`pwd`
cd $ubootName; ./make.sh;
cd $currentDir
cp $ubootName/uboot.img $BINARIES_DIR/u-boot.itb

# uboot creation
# to take rockchip-bsp's boot loaders, rather then generating our own ...
#cp ~/temp/rockchip-bsp/out/u-boot/idbloader.img ~/temp/rockchip-bsp/out/u-boot/u-boot.itb $BINARIES_DIR/
$ubootName/tools/mkimage -n rk3568 -T rksd -d $RKBIN/bin/rk35/rk3568_ddr_1056MHz_v1.08.bin:$ubootName/spl/u-boot-spl.bin $BINARIES_DIR/idbloader.img

# Generate the uboot script
$HOST_DIR/bin/mkimage -C none -A arm -T script -d $BR2_EXTERNAL_RK3308_PATH/board/RK3568/boot.cmd $BINARIES_DIR/boot.scr

# Put the device trees into the correct location
mkdir -p $BINARIES_DIR/rockchip; cp -a $BINARIES_DIR/*.dtb $BINARIES_DIR/rockchip
$BASE_DIR/../support/scripts/genimage.sh -c $BR2_EXTERNAL_RK3308_PATH/board/RK3568/genimage.cfg

echo
echo
echo compilation done
echo
echo
echo
echo write your image to the sdcard, don\'t forget to change OF=/dev/sdb to your sdcard drive ...
echo use the following command ...
echo
echo 'OF=/dev/sdb; rootDrive=`mount | grep " / " | grep $OF`; if [ -z $rootDrive ]; then sudo umount $OF[123456789]; sudo dd if=output/images/sdcard.img of=$OF bs=10M; else echo you are trying to overwrite your root drive; fi'
echo
