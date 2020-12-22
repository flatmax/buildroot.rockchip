################################################################################
#
# rktools
#
################################################################################

RKTOOLS_VERSION = c6095b2b0d5cb8bb43ed993ec03543298729da5a
RKTOOLS_SITE = https://github.com/rockchip-linux/tools.git
RKTOOLS_SITE_METHOD = git
RKTOOLS_INSTALL_IMAGES = YES

define RKTOOLS_INSTALL_IMAGES_CMDS
	mkdir $(BINARIES_DIR)/tools
	cp -a $(@D)/* $(BINARIES_DIR)/tools
endef

$(eval $(generic-package))
