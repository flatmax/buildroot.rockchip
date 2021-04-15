#! /bin/bash

if [ $# -lt 1 ]; then
  echo usage :
  me=`basename "$0"`
  echo "     " $me path.to.buildroot.neo
  echo for example :
  echo "     " $me /home/flatmax.unencrypted/buildroot.Bananapi
else
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

  CUSTOM_PATH=$DIR
  BR_REPO_PATH=$1
  BR_DEFCONFIG=''
  BR_RK3328_DEFCONFIG=rockpie_defconfig

  if [ ! -d "$BR_REPO_PATH" ]; then
  	echo Can\'t find the directory $BR_REPO_PATH please correct the bash script.
  	return;
  fi
  if [ ! -d "$CUSTOM_PATH" ]; then
  	echo Can\'t find the directory $CUSTOM_PATH please correct the bash script.
  	return;
  fi

  if [ ! -e $CUSTOM_PATH/configs/$BR_RK3328_DEFCONFIG ]; then
  	echo can\'t find the file $CUSTOM_PATH/configs/$BR_RK3328_DEFCONFIG
  	echo please fix this script
  	return;
  fi

  echo The setup script is in this directory $1

  cd $BR_REPO_PATH

  if [ ! -z $BR_DEFCONFIG ]; then
    echo using defined defconfig $BR_DEFCONFIG
    echo "###### DON'T EDIT THIS FILE, EDIT $BR_RK3328_DEFCONFIG INSTEAD" > $CUSTOM_PATH/configs/$BR_DEFCONFIG
    cat $BR_REPO_PATH/configs/$BR_DEFCONFIG >> $CUSTOM_PATH/configs/$BR_DEFCONFIG
    cat $CUSTOM_PATH/configs/$BR_RK3328_DEFCONFIG >> $CUSTOM_PATH/configs/$BR_DEFCONFIG
    make BR2_EXTERNAL=$CUSTOM_PATH $BR_DEFCONFIG
  else
    echo No original defconfig defined, no problem using $BR_RK3328_DEFCONFIG
    make BR2_EXTERNAL=$CUSTOM_PATH $BR_RK3328_DEFCONFIG
  fi
fi
