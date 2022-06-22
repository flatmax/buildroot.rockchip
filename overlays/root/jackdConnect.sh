#!/bin/sh
jack_load netmanager
sleep 4
jack_connect dev:from_slave_1 system:playback_1
jack_connect dev:from_slave_2 system:playback_2
jack_connect dev:to_slave_1 system:capture_1
jack_connect dev:to_slave_2 system:capture_2
