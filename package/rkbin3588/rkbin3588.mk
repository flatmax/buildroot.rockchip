################################################################################
#
# rkbin from gitlab
#
################################################################################

RKBIN3588_VERSION = ae710c9ebffa72785f162a397303cd63425b65a3
RKBIN3588_SITE = https://gitlab.com/rk3588_linux/rk/rkbin.git
RKBIN3588_SITE_METHOD = git
RKBIN3588_INSTALL_IMAGES = YES

define RKBIN3588_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/rkbin
	cp -a $(@D)/* $(BINARIES_DIR)/rkbin
endef

$(eval $(generic-package))
