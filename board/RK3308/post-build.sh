#!/bin/sh

RKBIN=$BINARIES_DIR/rkbin
RKTOOLS=$RKBIN/tools
RKCHIP_LOADER=$2
RKCHIP=$2

if [ $RKCHIP = "RK3308" ]; then
  if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' ${OUTDIR}/.config ; then
    PLATFORM_UBOOT_IMG_SIZE="--size 512 2"
  else
    PLATFORM_UBOOT_IMG_SIZE="--size 1024 2"
  fi
fi

# <*> Fixup PLATFORM_AARCH32 for ARM64 cpu platforms
if [ $RKCHIP = "RK3308" ]; then
  if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' ${OUTDIR}/.config ; then
    PLATFORM_AARCH32="AARCH32"
  fi
fi

# first loader creation
cd $RKBIN; ${RKTOOLS}/boot_merger --replace tools/rk_tools/ ./ ${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini
echo "pack loader okay! Input: ${RKBIN}/RKBOOT/${RKCHIP_LOADER}MINIALL.ini"
cd $BINARIES_DIR
LOADER_OUTS=`ls ${RKBIN}/*_loader_*.bin`
echo loader outputs : $LOADER_OUTS
ln -fs $LOADER_OUTS .

# uboot creation
#ubootName=`find $BASE_DIR/build -name 'uboot-*' -type d`
#cat $ubootName/.config | grep CONFIG_SYS_TEXT_BASE | sed 's/^.*=//'
#ubootAdd=`cat $ubootName/.config | grep CONFIG_SYS_TEXT_BASE | sed 's/^.*=//'`
#echo uboot address = $ubootAdd
#${RKTOOLS}/loaderimage --pack --uboot $BINARIES_DIR/u-boot.img $BINARIES_DIR/u-boot.packed.img $ubootAdd ${PLATFORM_UBOOT_IMG_SIZE}
#echo u-boot.packed.img created

boardDir=`dirname $_`
echo $boardDir
$boardDir/packTrustImage.sh $RKCHIP

$boardDir/makeImage.sh

#$BASE_DIR/../support/scripts/genimage.sh -c $BR2_EXTERNAL_RK3308_PATH/board/RK3308/genimage.cfg
