#!/bin/sh

RKBIN=$BINARIES_DIR/rkbin
RKTOOLS=$RKBIN/tools
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

# uboot creation
# #$RKTOOLS/loaderimage --pack --uboot $ubootName/u-boot-dtb.bin $BINARIES_DIR/uboot.img 0x600000
# #$ubootName/tools/loaderimage --pack --uboot $ubootName/u-boot-dtb.bin $BINARIES_DIR/uboot.img 0x600000 --size 1024 1
# #cp $ubootName/u-boot.img $BINARIES_DIR/uboot.img
# locDir=`pwd`
# cd $ubootName
# #make BL31=$RKBIN/bin/rk35/rk3568_bl31_v1.20.elf spl/u-boot-spl.bin u-boot.dtb $BINARIES_DIR/u-boot.itb
# #make BL31=$RKBIN/bin/rk35/rk3568_bl31_v1.24.elf spl/u-boot-spl.bin u-boot.dtb $BINARIES_DIR/u-boot.itb
# #./tools/mkimage -n rk356x -T rksd -d $RKBIN/bin/rk35/rk3568_ddr_1056MHz_v1.06.bin:spl/u-boot-spl.bin $BINARIES_DIR/idbloader.img
# #cp u-boot.itb $BINARIES_DIR/
# $ubootName/tools/mkimage -n rk356x -T rksd -d $RKBIN/bin/rk35/rk3568_ddr_1056MHz_v1.08.bin:$ubootName/spl/u-boot-spl.bin $BINARIES_DIR/idbloader.img
# cd $locDir


# # trust img creation
# cat >$ubootName/trust.ini <<EOF
# [VERSION]
# MAJOR=1
# MINOR=0
# [BL30_OPTION]
# SEC=0
# [BL31_OPTION]
# SEC=1
# PATH=$BR2_EXTERNAL_RK3308_PATH/board/RK3566/rk3568_bl31_v1.24.elf
# ADDR=0x00040000
# [BL32_OPTION]
# SEC=1
# PATH=$BR2_EXTERNAL_RK3308_PATH/board/RK3566/rk3568_bl32_v1.05.bin
# ADDR=0x08400000
# [BL33_OPTION]
# SEC=0
# [OUTPUT]
# PATH=$BINARIES_DIR/trust.img
# EOF
# $RKBIN/tools/trust_merger --size 1024 1 ${ubootName}/trust.ini

# # first stage boot loader creation
# $ubootName/tools/mkimage -n rk356x -T rksd -d $boardDir/rk3566_ddr_1056MHz_v1.08.bin $BINARIES_DIR/idbloader.img
# #cat $boardDir/rk3308_miniloader_emmc_port_support_sd_20190717.bin >> $BINARIES_DIR/idbloader.img

# manually copy known working loaders :
#cp $BR2_EXTERNAL_RK3308_PATH/board/RK3568/idbloader.img $BR2_EXTERNAL_RK3308_PATH/board/RK3568/uboot.img $BR2_EXTERNAL_RK3308_PATH/board/RK3568/trust.img $BINARIES_DIR/

# Generate the uboot script
$ubootName/tools/mkimage -C none -A arm -T script -d $BR2_EXTERNAL_RK3308_PATH/board/RK3568/boot.cmd $BINARIES_DIR/boot.scr

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
echo 'OF=/dev/sdc; rootDrive=`mount | grep " / " | grep $OF`; if [ -z $rootDrive ]; then sudo umount $OF[123456789]; sudo dd if=output/images/sdcard.img of=$OF; else echo you are trying to overwrite your root drive; fi'
echo
echo
echo images from sdcard :
echo dd if=/dev/sdc of=/tmp/idbloader.img skip=64 count=16320 bs=512
echo dd if=/dev/sdc of=/tmp/uboot.img skip=16384 count=8192 bs=512
echo dd if=/dev/sdc of=/tmp/trust.img skip=24576 count=8192 bs=512
# echo sudo dd if=/dev/sdc of=/tmp/idbloader.img seek=64 count=16000 bs=1k
# echo sudo dd if=/dev/sdc of=/tmp/uboot.img seek=16384 count=8000 bs=1k
# echo sudo dd if=/dev/sdc of=/tmp/trust.img seek=24576 count=8000 bs=1k
echo
echo
