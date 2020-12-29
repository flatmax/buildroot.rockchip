fatload mmc ${devnum}:${distro_bootpart} ${fdt_addr_r} ${fdtfile}
fatload mmc ${devnum}:${distro_bootpart} ${kernel_addr_c} Image
booti ${kernel_addr_c} - ${fdt_addr_r}
