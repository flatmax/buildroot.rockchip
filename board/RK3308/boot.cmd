setenv bootargs "root=/dev/mmcblk0p2 earlyprintk console=ttyS0,115200n8 rw rootwait"
fatload mmc ${devnum}:${distro_bootpart} ${fdt_addr_r} ${fdtfile}
fatload mmc ${devnum}:${distro_bootpart} ${kernel_addr_r} Image
booti ${kernel_addr_r} - ${fdt_addr_r}
