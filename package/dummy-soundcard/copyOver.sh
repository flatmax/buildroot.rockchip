VERSION=5.17.13
host=root@rk3399.local
driverDir=output/build/dummy-soundcard-0.0.1/module-dummy-soundcard
modDir=/lib/modules/$VERSION/kernel/sound/soc/rockchip
files=$driverDir/*.ko
for f in $files; do
  echo   scp $f root@rk3399.local:$modDir
  scp $f root@rk3399.local:$modDir
done


ssh root@rk3399.local "mkdir -p /tmp/boot; mount /dev/mmcblk1p1 /tmp/boot; ls -l /tmp/boot/rockchip/overlays"
driverDir=output/build/dummy-soundcard-0.0.1/module-dummy-soundcard
scp $driverDir/*.dtbo root@rk3399.local:/tmp/boot/rockchip/overlays
ssh root@rk3399.local "ls -l /tmp/boot/rockchip/overlays; umount /tmp/boot"
echo
echo Reboot as the dtbo has changed.
echo
