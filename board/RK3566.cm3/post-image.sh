#!/bin/dash

RKBIN=$BINARIES_DIR/rkbin
RKCHIP_LOADER=$2
RKCHIP=$2

# copy uboot variable file over
cp -a $BR2_EXTERNAL_RK3308_PATH/board/RK3566.cm3/vars.txt $BINARIES_DIR/

# copy overlays over
linuxDir=`find $BASE_DIR/build -name 'vmlinux' -type f | xargs dirname`
mkdir -p $BINARIES_DIR/rockchip/overlays
if [ -d ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay ]; then
  cp -a ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay/*.dtbo $BINARIES_DIR/rockchip/overlays
fi

ubootName=`find $BASE_DIR/build -name 'uboot-*' -type d`
boardDir=`dirname $_`

#echo creating uboot.img
#cp $ubootName/u-boot.img $BINARIES_DIR/uboot.img
#$RKBIN/tools/loaderimage --pack --uboot $ubootName/u-boot-dtb.bin $BINARIES_DIR/uboot.img
currentDir=`pwd`
cd $ubootName; ./make.sh;
cd $currentDir
cp $ubootName/uboot.img $BINARIES_DIR/u-boot.itb

# to take rockchip-bsp's boot loaders, rather then generating our own ...
echo creating idbloader.img
$ubootName/tools/mkimage -n rk3568 -T rksd -d $RKBIN/bin/rk35/rk3566_ddr_1056MHz_v1.08.bin:$ubootName/spl/u-boot-spl.bin $BINARIES_DIR/idbloader.img
#$ubootName/tools/mkimage -n rk3568 -T rksd -d $RKBIN/bin/rk35/rk3566_ddr_1056MHz_v1.08.bin $BINARIES_DIR/idbloader.img
#cat ${RKBIN}/bin/rk35/rk3568_bl31_v1.24.elf >> $BINARIES_DIR/idbloader.img
#${boardDir}/mkRK3566Boot.sh ${BINARIES_DIR} ${RKBIN} rk356x_spl_loader_v1.08.111.bin
#cp $BINARIES_DIR/rk356x_spl_loader_v1.08.111.bin $BINARIES_DIR/idbloader.img
#cp $ubootName/rk356x_spl_loader_v1.08.111.bin $BINARIES_DIR/idbloader.img

# Generate the uboot script
echo creating boot.scr
$ubootName/tools/mkimage -C none -A arm -T script -d $BR2_EXTERNAL_RK3308_PATH/board/RK3566.cm3/boot.cmd $BINARIES_DIR/boot.scr

#make the trust image
echo creating trust.img
${boardDir}/mkRK3566Trust.sh ${BINARIES_DIR} ${RKBIN} trust.img

# Put the device trees into the correct location
mkdir -p $BINARIES_DIR/rockchip; cp -a $BINARIES_DIR/*.dtb $BINARIES_DIR/rockchip
$BASE_DIR/../support/scripts/genimage.sh -c $BR2_EXTERNAL_RK3308_PATH/board/RK3566.cm3/genimage.cfg

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
# echo
# echo
# echo
# echo NOTE: Uboot booting is currently a manual process. Upon boot when you are stopped in uboot in the console, execute the following :
# echo
# echo setenv devnum 1
# echo
# echo now copy and paste the contents of RK3566.cm3/boot.cmd into the uboot console. Linux will boot. Login as appropriate
# echo
