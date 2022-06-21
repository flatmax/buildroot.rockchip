#!/bin/dash

# BOARD_DIR="$(dirname $0)"
ubootName=`find $BASE_DIR/build -name 'uboot-*' -type d`
boardDir=`dirname $_`

RKBIN=$BINARIES_DIR/rkbin

#make the first stage boot loader
echo idbloader.img
$ubootName/tools/mkimage -n rk3399pro -T rksd -d ${RKBIN}/bin/rk33/rk3399pro_ddr_800MHz_v1.25.bin $BINARIES_DIR/idbloader.img
cat ${RKBIN}/bin/rk33/rk3399pro_miniloader_v1.26.bin >> $BINARIES_DIR/idbloader.img

# uboot creation
echo uboot.img
$RKBIN/tools/loaderimage --pack --uboot $ubootName/u-boot-dtb.bin $BINARIES_DIR/uboot.img

# Generate the uboot script
echo boot.scr
$ubootName/tools/mkimage -C none -A arm -T script -d ${boardDir}/boot.cmd $BINARIES_DIR/boot.scr

# alter the vars.txt file
echo vars.txt
dtbName=`grep ^BR2_LINUX_KERNEL_INTREE_DTS_NAME $BR2_CONFIG | sed 's/^.*=//;s/"//g'`
sed -i "s|.*fdt_name.*|fdt_name=$dtbName.dtb|" ${boardDir}/vars.txt
# copy uboot variable file over
cp -a ${boardDir}/vars.txt $BINARIES_DIR/

#make the trust image
echo trust.img
${boardDir}/mkRk3399ProTrust.bin.sh ${BINARIES_DIR} ${RKBIN} trust.img

# copy the device tree and overlays over
linuxDir=`find $BASE_DIR/build -name 'vmlinux' -type f | xargs dirname`
if [ ! -d $BINARIES_DIR/rockchip/overlays ]; then
  mkdir -p $BINARIES_DIR/rockchip/overlays
fi
if [ -d ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay ]; then
  cp -a ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay/*.dtbo $BINARIES_DIR/rockchip/overlays
fi
cp -a ${linuxDir}/arch/arm64/boot/dts/${dtbName}.dtb $BINARIES_DIR/rockchip

# generate the image
$BASE_DIR/../support/scripts/genimage.sh -c ${boardDir}/genimage.cfg

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
echo

#
# # RKBIN=$BINARIES_DIR/rkbin
# # RKTOOLS=$RKBIN/tools
# # RKCHIP_LOADER=$2
# # RKCHIP=$2
# #
# # # copy uboot variable file over
# # cp -a $BR2_EXTERNAL_RK3308_PATH/board/RK3566/vars.txt $BINARIES_DIR/
# #
# # # copy overlays over
# # linuxDir=`find $BASE_DIR/build -name 'vmlinux' -type f | xargs dirname`
# # mkdir -p $BINARIES_DIR/rockchip/overlays
# # if [ -d ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay ]; then
# #   cp -a ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay/*.dtbo $BINARIES_DIR/rockchip/overlays
# # fi
# #
# # ubootName=`find $BASE_DIR/build -name 'uboot-*' -type d`
# # boardDir=`dirname $_`
# #
# # # uboot creation
# # $RKTOOLS/loaderimage --pack --uboot $ubootName/u-boot-dtb.bin $BINARIES_DIR/uboot.img 0x600000
# # #$ubootName/tools/loaderimage --pack --uboot $ubootName/u-boot-dtb.bin $BINARIES_DIR/uboot.img 0x600000 --size 1024 1
# # #cp $ubootName/u-boot.img $BINARIES_DIR/uboot.img
# #
# # # trust img creation
# # cat >$ubootName/trust.ini <<EOF
# # [VERSION]
# # MAJOR=1
# # MINOR=0
# # [BL30_OPTION]
# # SEC=0
# # [BL31_OPTION]
# # SEC=1
# # PATH=$BR2_EXTERNAL_RK3308_PATH/board/RK3566/rk3568_bl31_v1.24.elf
# # ADDR=0x00040000
# # [BL32_OPTION]
# # SEC=1
# # PATH=$BR2_EXTERNAL_RK3308_PATH/board/RK3566/rk3568_bl32_v1.05.bin
# # ADDR=0x08400000
# # [BL33_OPTION]
# # SEC=0
# # [OUTPUT]
# # PATH=$BINARIES_DIR/trust.img
# # EOF
# # $RKBIN/tools/trust_merger --size 1024 1 ${ubootName}/trust.ini
# #
# # # first stage boot loader creation
# # $ubootName/tools/mkimage -n rk356x -T rksd -d $boardDir/rk3566_ddr_1056MHz_v1.08.bin $BINARIES_DIR/idbloader.img
# # #cat $boardDir/rk3308_miniloader_emmc_port_support_sd_20190717.bin >> $BINARIES_DIR/idbloader.img
# #
# # # Generate the uboot script
# # $ubootName/tools/mkimage -C none -A arm -T script -d $BR2_EXTERNAL_RK3308_PATH/board/RK3566/boot.cmd $BINARIES_DIR/boot.scr
# #
# # # Put the device trees into the correct location
# # mkdir -p $BINARIES_DIR/rockchip; cp -a $BINARIES_DIR/*.dtb $BINARIES_DIR/rockchip
# # $BASE_DIR/../support/scripts/genimage.sh -c $BR2_EXTERNAL_RK3308_PATH/board/RK3566/genimage.cfg
# #
# # echo
# # echo
# # echo compilation done
# # echo
# # echo
# # echo
# # echo write your image to the sdcard, don\'t forget to change OF=/dev/sdb to your sdcard drive ...
# # echo use the following command ...
# # echo
# # echo 'OF=/dev/sdb; rootDrive=`mount | grep " / " | grep $OF`; if [ -z $rootDrive ]; then sudo umount $OF[123456789]; sudo dd if=output/images/sdcard.img of=$OF bs=10M; else echo you are trying to overwrite your root drive; fi'
# # echo
# # echo
