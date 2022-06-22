snd-soc-bare-codec-objs := bare-codec.o
obj-$(CONFIG_SND_SOC_DUMMY_SOUNDCARD)  += snd-soc-bare-codec.o

# older kernels
dtb-y += dummy-soundcard.dtbo

%.dtbo: %.dts
	dtc -o dtb -o $@ -b 0 -@ $<

targets += $(dtb-y)
always	:= $(dtb-y)
clean-files	:= *.dtbo

# newer kernels
# dtbo-y += dummy-soundcard.dtbo
#
# %.dtbo: %.dts
# 	dtc -o dtb -o $@ -b 0 -@ $<
#
# targets += $(dtbo-y)
# always-y  := $(dtbo-y)
