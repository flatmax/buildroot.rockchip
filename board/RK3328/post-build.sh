#!/bin/dash

# fix eth0
cnt=`grep -c eth0 $TARGET_DIR/etc/network/interfaces`
if [ $cnt -eq "0" ]; then
  echo "">> $TARGET_DIR/etc/network/interfaces
  echo "auto eth0">> $TARGET_DIR/etc/network/interfaces
  echo "iface eth0 inet dhcp">> $TARGET_DIR/etc/network/interfaces
fi
