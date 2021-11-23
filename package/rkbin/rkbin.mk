################################################################################
#
# rkbin
#
################################################################################

RKBIN_VERSION = 7d631e0d5b2d373b54d4533580d08fb9bd2eaad4
RKBIN_SITE = https://github.com/rockchip-linux/rkbin.git
RKBIN_SITE_METHOD = git
RKBIN_INSTALL_IMAGES = YES

define RKBIN_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/rkbin
	cp -a $(@D)/* $(BINARIES_DIR)/rkbin
#	cp $(@D)/bin/rk33/rk3308_ddr_589MHz_uart2_m1_v1.30.bin $(BINARIES_DIR)
#	cp $(@D)/bin/rk33/rk3308_miniloader_v1.19.bin $(BINARIES_DIR)
#	cp $(@D)/bin/rk33/rk3308_bl31_v2.22.elf $(BINARIES_DIR)
endef

$(eval $(generic-package))
