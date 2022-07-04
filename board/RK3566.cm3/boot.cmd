echo "loading boot vars"
setenv load_addr $ramdisk_addr_r
setenv devnum 1
load mmc ${devnum} ${load_addr} vars.txt
env import -t ${load_addr} ${filesize}
#setenv fdtfile "rk3566-rock-cm3-e23-io.dtb"

echo "setting boot args"
setenv bootargs "root=/dev/mmcblk0p2 earlyprintk console=ttyS2,1500000n8 rw rootwait"
fatload mmc ${devnum}:${distro_bootpart} ${fdt_addr_r} ${fdtfile}
fatload mmc ${devnum}:${distro_bootpart} ${kernel_addr_r} Image

# append overlays as required
setenv overlay_error "false"
fdt addr ${fdt_addr_r}
fdt resize 65536
for overlay_file in ${overlays}; do
  echo "loading overlay ${overlay_file}"
	if fatload mmc ${devnum}:${distro_bootpart} ${load_addr} rockchip/overlays/${overlay_file}.dtbo; then
		echo "Applying kernel provided DT overlay ${overlay_file}.dtbo"
		fdt apply ${load_addr} || setenv overlay_error "true"
	fi
done
if test "${overlay_error}" = "true"; then
	echo "Error applying DT overlays, restoring original DT"
  fatload mmc ${devnum}:${distro_bootpart} ${fdt_addr_r} ${fdtfile}
fi

echo booting linux ...
booti ${kernel_addr_r} - ${fdt_addr_r}
