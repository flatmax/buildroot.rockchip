#!/bin/dash

RKBIN=$BINARIES_DIR/rkbin
RKTOOLS=$RKBIN/tools
RKCHIP_LOADER=$2
RKCHIP=$2

if [ $RKCHIP = "RK3328" ]; then
  if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' ${BASE_DIR}/../.config ; then
    PLATFORM_UBOOT_IMG_SIZE="--size 512 2"
    PLATFORM_AARCH32="AARCH32"
  else
    PLATFORM_UBOOT_IMG_SIZE="--size 1024 2"
  fi
fi

# copy uboot variable file over
cp -a $BR2_EXTERNAL_RK3308_PATH/board/RK3328/vars.txt $BINARIES_DIR/

# copy overlays over
linuxDir=`find $BASE_DIR/build -name 'vmlinux' -type f | xargs dirname`
mkdir -p $BINARIES_DIR/rockchip/overlays
cp -a ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay/*.dtbo $BINARIES_DIR/rockchip/overlays

boardDir=`dirname $_`
ubootName=`find $BINARIES_DIR/../build/u* -name 'mkimage' | grep tools | sed 's|/tools/mkimage||'`
ATFName=`find $BINARIES_DIR/../build/arm-trusted-firmware* -name 'bl31.elf'`

# uboot creation
$RKTOOLS/loaderimage --pack --uboot $ubootName/u-boot-dtb.bin $BINARIES_DIR/uboot.img 0x200000

# trust img creation
# cat >$ubootName/trust.ini <<EOF
# [VERSION]
# MAJOR=1
# MINOR=0
# [BL30_OPTION]
# SEC=0
# [BL31_OPTION]
# SEC=1
# PATH=$ATFName
# ADDR=0x00010000
# [BL32_OPTION]
# SEC=0
# [BL33_OPTION]
# SEC=0
# [OUTPUT]
# PATH=$BINARIES_DIR/trust.img
# EOF
# $RKBIN/tools/trust_merger ${ubootName}/trust.ini

cat >$ubootName/trust.ini <<EOF
[VERSION]
MAJOR=1
MINOR=2
[BL30_OPTION]
SEC=0
[BL31_OPTION]
SEC=1
PATH=$RKBIN/bin/rk33/rk322xh_bl31_v1.44.elf
ADDR=0x40000
[BL32_OPTION]
SEC=1
PATH=$RKBIN/bin/rk33/rk322xh_bl32_v2.01.bin
ADDR=0x08400000
[BL33_OPTION]
SEC=0
[OUTPUT]
PATH=$BINARIES_DIR/trust.img
EOF
$RKBIN/tools/trust_merger ${ubootName}/trust.ini

# first stage boot loader creation
#$ubootName/tools/mkimage -n rk3328 -T rksd -d $boardDir/rk3328_ddr_589MHz_uart0_m0_v1.26.bin $BINARIES_DIR/idbloader.img
#cat $boardDir/rk3328_miniloader_emmc_port_support_sd_20190717.bin >> $BINARIES_DIR/idbloader.img
#$ubootName/tools/mkimage -n rk3328 -T rksd -d $boardDir/rk3328_ddr_333MHz_v1.16.bin $BINARIES_DIR/idbloader.img
#cat $boardDir/rk322xh_miniloader_v2.50.bin >> $BINARIES_DIR/idbloader.img
$ubootName/tools/mkimage -n rk3328 -T rksd -d $RKBIN/bin/rk33/rk3328_ddr_400MHz_v1.16.bin $BINARIES_DIR/idbloader.img
cat $RKBIN/bin/rk33/rk322xh_miniloader_v2.50.bin >> $BINARIES_DIR/idbloader.img

# Generate the uboot script
$ubootName/tools/mkimage -C none -A arm -T script -d $BR2_EXTERNAL_RK3308_PATH/board/RK3328/boot.cmd $BINARIES_DIR/boot.scr

# Put the device trees into the correct location
mkdir -p $BINARIES_DIR/rockchip; cp -a $BINARIES_DIR/*.dtb $BINARIES_DIR/rockchip
$BASE_DIR/../support/scripts/genimage.sh -c $BR2_EXTERNAL_RK3308_PATH/board/RK3328/genimage.cfg

echo
echo
echo compilation done
echo
echo
echo
echo write your image to the sdcard, don\'t forget to change OF=/dev/sdb to your sdcard drive ...
echo use the following command ...
echo
echo 'OF=/dev/sdb; rootDrive=`mount | grep " / " | grep $OF`; if [ -z $rootDrive ]; then sudo umount $OF[123456789]; sudo dd if=output/images/sdcard.img of=$OF; else echo you are trying to overwrite your root drive; fi'
echo
echo
