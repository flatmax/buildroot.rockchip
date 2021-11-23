################################################################################
#
# rktools
#
################################################################################

RKTOOLS_VERSION = 26f53bb08db8ab9f4e6236e230f1ba3ae3a45434
RKTOOLS_SITE = https://github.com/rockchip-linux/tools.git
RKTOOLS_SITE_METHOD = git
RKTOOLS_INSTALL_IMAGES = YES

define RKTOOLS_INSTALL_IMAGES_CMDS
	mkdir $(BINARIES_DIR)/tools
	cp -a $(@D)/* $(BINARIES_DIR)/tools
endef

$(eval $(generic-package))
