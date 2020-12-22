################################################################################
#
# RKDEVICE
#
################################################################################

RKDEVICE_VERSION = 0fe366cf14a6d5d552a5bddbc7b8ff58260ae6e6
RKDEVICE_SITE = https://github.com/rockchip-linux/device-custom.git
RKDEVICE_SITE_METHOD = git
RKDEVICE_INSTALL_IMAGES = YES

define RKDEVICE_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/device
	cp -a $(@D)/* $(BINARIES_DIR)/device
endef

$(eval $(generic-package))
