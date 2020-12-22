#!/bin/bash

RKBIN=$BINARIES_DIR/rkbin
RKTOOLS=$RKBIN/tools
RKCHIP=$1
RKCHIP_TRUST=${RKCHIP}

if [ $RKCHIP = "RK3308" ]; then
  if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' $BR2_CONFIG ; then
    PLATFORM_AARCH32="AARCH32"
  fi
fi

# RK3308/PX30/RK3326 use RSA-PKCS1 V2.1, it's pack magic is "3"
if [ $RKCHIP = "PX30" -o $RKCHIP = "RK3326" -o $RKCHIP = "RK3308" ]; then
  PLATFORM_RSA="--rsa 3"
# RK3368 use rk big endian SHA256, it's pack magic is "2"
elif [ $RKCHIP = "RK3368" ]; then
  PLATFORM_SHA="--sha 2"
# other platforms use default configure
fi

if [ $RKCHIP = "RK3308" ]; then
  if grep -q '^CONFIG_ARM64_BOOT_AARCH32=y' ${OUTDIR}/.config ; then
    PLATFORM_TRUST_IMG_SIZE="--size 512 2"
  else
    PLATFORM_TRUST_IMG_SIZE="--size 1024 2"
  fi
fi

# uboot location
ubootName=`find $BASE_DIR/build -name 'uboot-*' -type d`
ubootConfig=$ubootName/.config
# ARM64 uses trust_merger
if grep -Eq ''^CONFIG_ARM64=y'|'^CONFIG_ARM64_BOOT_AARCH32=y'' $ubootConfig ; then
  if [ ! -f ${RKBIN}/RKTRUST/${RKCHIP_TRUST}${PLATFORM_AARCH32}TRUST.ini ]; then
    echo "pack trust failed! Can't find: ${RKBIN}/RKTRUST/${RKCHIP_TRUST}${PLATFORM_AARCH32}TRUST.ini"
    return
  fi

  cd ${RKBIN}
  ${RKTOOLS}/trust_merger ${PLATFORM_SHA} ${PLATFORM_RSA} ${PLATFORM_TRUST_IMG_SIZE} --replace tools/rk_tools/ ./ ${RKBIN}/RKTRUST/${RKCHIP_TRUST}${PLATFORM_AARCH32}TRUST.ini

  mv ${RKBIN}/trust.img $BINARIES_DIR/trust.img
  echo "pack trust okay! Input: ${RKBIN}/RKTRUST/${RKCHIP_TRUST}${PLATFORM_AARCH32}TRUST.ini"
  echo trust.img written
else
  echo trust for this case is not handled here, integrate code from ROC-RK3308-CC.SDK/make.sh
fi
