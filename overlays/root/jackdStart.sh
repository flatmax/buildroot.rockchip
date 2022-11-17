#!/bin/sh
killall aplay
killall jackd

modprobe snd-soc-bare-codec.ko

SCARD=hw:0
sleep 2
#jackd -P 95 -d alsa -r 96000 &
jackd -R -d alsa -d $SCARD -r 96000 &
sleep 2
./jackdConnect.sh
