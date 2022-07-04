#!/usr/bin/env bash
cat >$1/RK3566MINIALL.ini <<EOF
[CHIP_NAME]
NAME=RK3568
[VERSION]
MAJOR=1
MINOR=1
[CODE471_OPTION]
NUM=1
Path1=$2/bin/rk35/rk3566_ddr_1056MHz_v1.08.bin
Sleep=1
[CODE472_OPTION]
NUM=1
Path1=$2/bin/rk35/rk356x_usbplug_v1.08.bin
[LOADER_OPTION]
NUM=2
LOADER1=FlashData
LOADER2=FlashBoot
FlashData=$2/bin/rk35/rk3566_ddr_1056MHz_v1.08.bin
FlashBoot=$2/bin/rk35/rk356x_spl_v1.11.bin
[OUTPUT]
PATH=$1/$3
[SYSTEM]
NEWIDB=true
[FLAG]
471_RC4_OFF=true
RC4_OFF=true
EOF
$2/tools/boot_merger $1/RK3566MINIALL.ini
