################################################################################
#
# rkbin
#
################################################################################

RKBIN_VERSION = fc44f9401c127affb2a879c1e90fa89ddab505f6
RKBIN_SITE = git@github.com:radxa/rkbin.git
RKBIN_SITE_METHOD = git
RKBIN_INSTALL_IMAGES = YES

define RKBIN_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/rkbin
	cp -a $(@D)/* $(BINARIES_DIR)/rkbin
endef

$(eval $(generic-package))
