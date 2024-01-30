#!/bin/dash

RKBIN=$BINARIES_DIR/rkbin
RKCHIP_LOADER=$2
RKCHIP=$2

UBOOT_DIR=`find $BASE_DIR/build -name 'uboot-*' -type d | head -n 1`
LINUX_DIR=`find $BASE_DIR/build -name 'vmlinux' -type f | xargs dirname`

# copy uboot variable file over
cp -a $BR2_EXTERNAL_RK3308_PATH/board/RK3568/vars.txt $BINARIES_DIR/

# overlays are no longer compiled in kernel as dtbo, add to overlays dir and copy to binaries dir
mkdir -p $BINARIES_DIR/rockchip/overlays
cp -a $BR2_EXTERNAL_RK3308_PATH/board/RK3568/overlays/* $BINARIES_DIR/rockchip/overlays/
cp $LINUX_DIR/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dtb $BINARIES_DIR/rockchip/rk3568-rock-3a.dtb

echo copying uboot.itb
cp $UBOOT_DIR/u-boot.itb $BINARIES_DIR/u-boot.itb

# uboot creation
# to take rockchip-bsp's boot loaders, rather then generating our own ...
#cp ~/temp/rockchip-bsp/out/u-boot/idbloader.img ~/temp/rockchip-bsp/out/u-boot/u-boot.itb $BINARIES_DIR/
$UBOOT_DIR/tools/mkimage -n rk3568 -T rksd -d $RKBIN/bin/rk35/rk3568_ddr_1056MHz_v1.08.bin:$UBOOT_DIR/spl/u-boot-spl.bin $BINARIES_DIR/idbloader.img

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
echo 'OF=/dev/sdc; rootDrive=`mount | grep " / " | grep $OF`; if [ -z $rootDrive ]; then sudo umount $OF[123456789]; sudo dd if=output/images/sdcard.img of=$OF bs=10M; else echo you are trying to overwrite your root drive; fi'
echo
