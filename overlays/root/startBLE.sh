echo 0 > /sys/class/rfkill/rfkill0/state
echo 1 > /sys/class/rfkill/rfkill0/state
modprobe hci_uart
rtk_hciattach -n -s 115200 /dev/ttyS4 rtk_h5 &
hciconfig -a
hciconfig hci0 up
hciconfig -a
