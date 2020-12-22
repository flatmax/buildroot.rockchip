
#!/bin/bash

ROCKDEV=$BINARIES_DIR/rk3308/Image
mkdir -p $ROCKDEV

# export PARAMETER=$BINARIES_DIR/device/rk3308/parameter-64bit.txt
export PARAMETER=$BR2_EXTERNAL_ROCKPIS_PATH/board/RockPiS/parameter-64bit-vanilla.txt

export PACKAGE_FILE=$BINARIES_DIR/tools/linux/Linux_Pack_Firmware/rockdev/rk3308-package-file

# Set oem partition type, including ext2 squashfs
export OEM_FS_TYPE=ext2
# Set userdata partition type, including ext2, fat
export USERDATA_FS_TYPE=ext2
#OEM config: /oem/dueros/aispeech-6mic-64bit/aispeech-2mic-64bit/aispeech-4mic-32bit/aispeech-2mic-32bit/aispeech-2mic-kongtiao-32bit/iflytekSDK/CaeDemo_VAD/smart_voice/alexa
#export OEM_DIR=dueros

export UBOOT_IMG=$BINARIES_DIR/u-boot.img
export TRUST_IMG=$BINARIES_DIR/trust.img
export LOADER_IMG=$BINARIES_DIR/rk3308_loader_v1.30.119.bin
export BOOT_IMG=$BINARIES_DIR/Image
export ROOTFS_IMG=$BINARIES_DIR/rootfs.ext4

cp -aL $ROOTFS_IMG $ROCKDEV/rootfs.img
cp -aL $PARAMETER $ROCKDEV/parameter.txt
echo '' > $ROCKDEV/recovery.img
#cp -aL $RECOVERY_IMG $ROCKDEV/recovery.img
#cp -aL $MISC_IMG $ROCKDEV/misc.img
#$MKOEM $OEM_DIR $ROCKDEV/oem.img $OEM_FS_TYPE
echo '' > $ROCKDEV/oem.img
echo '' > $ROCKDEV/misc.img

# $BINARIES_DIR/device/common/mk-image.sh $BINARIES_DIR/device/userdata/userdata_empty $ROCKDEV/userdata.img $RK_USERDATA_FS_TYPE
rm -rf $ROCKDEV/userdata.img
dd of=$ROCKDEV/userdata.img bs=1M seek=20M count=0
mke2fs -t $RK_USERDATA_FS_TYPE $ROCKDEV/userdata.img -d $BINARIES_DIR/device/userdata/userdata_empty
tune2fs -c 0 -i 0 $ROCKDEV/userdata.img
#$MKUSERDATA $USER_DATA_DIR $ROCKDEV/userdata.img $RK_USERDATA_FS_TYPE
cp -aL $UBOOT_IMG $ROCKDEV/uboot.img
cp -aL $TRUST_IMG $ROCKDEV/trust.img
cp -aL $LOADER_IMG $ROCKDEV/MiniLoaderAll.bin
cp -aL $BOOT_IMG $ROCKDEV/boot.img
cp -aL $PACKAGE_FILE $ROCKDEV/../package-file

cd $ROCKDEV/..
pwd
ls
echo "start to make update.img..."
if [ ! -f "Image/parameter.txt" ]; then
	echo "Error:No found parameter!"
	exit 1
fi
if [ ! -f "package-file" ]; then
	echo "Error:No found package-file!"
	exit 1
fi
$BINARIES_DIR/tools/linux/Linux_Pack_Firmware/rockdev/afptool -pack ./ Image/update.img
cd Image
$BINARIES_DIR/tools/linux/Linux_Pack_Firmware/rockdev/rkImageMaker -RK3308 ./MiniLoaderAll.bin ./update.img ../update.img -os_type:androidos
echo "Making update.img OK."
ln -s $ROCKDEV/../update.img $ROCKDEV/../../sdcard2.img

echo write your image :
echo "OF=/dev/sdf; rootDrive=`mount | grep ' / ' | grep $OF`; if [ -z $rootDrive ]; then sudo umount $OF[123456789]; sudo dd if=output/images/sdcard2.img of=$OF; else echo you are trying to overwrite your root drive; fi"

#echo "Press any key to quit:"
#read -n1 -s key
exit $?
