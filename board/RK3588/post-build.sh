#!/bin/dash

# fix eth0
cnt=`grep -c eth0 $TARGET_DIR/etc/network/interfaces`
if [ $cnt -eq "0" ]; then
  echo "">> $TARGET_DIR/etc/network/interfaces
  echo "auto eth0">> $TARGET_DIR/etc/network/interfaces
  echo "iface eth0 inet dhcp">> $TARGET_DIR/etc/network/interfaces
fi

# modules
if [ ! -f $TARGET_DIR/etc/init.d/S02modules ]; then
  cp $BR2_EXTERNAL_RK3308_PATH/board/RK3588/S02modules $TARGET_DIR/etc/init.d
fi
if [ ! -f $TARGET_DIR/etc/modules ]; then
  echo 'r8125.ko' > $TARGET_DIR/etc/modules
fi
