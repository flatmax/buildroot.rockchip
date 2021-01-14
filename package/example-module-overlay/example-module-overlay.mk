################################################################################
#
# example-module-overlay
#
################################################################################

EXAMPLE_MODULE_OVERLAY_VERSION = 0.0.1
EXAMPLE_MODULE_OVERLAY_SITE = $(BR2_EXTERNAL)/package/example-module-overlay
EXAMPLE_MODULE_OVERLAY_SITE_METHOD = local
EXAMPLE_MODULE_OVERLAY_DEPENDENCIES =

EXAMPLE_MODULE_OVERLAY_MODULE_SUBDIRS = module-overlay-rk3308
EXAMPLE_MODULE_OVERLAY_MODULE_MAKE_OPTS = \
	INSTALL_MOD_DIR=kernel/sound/soc/rockchip \
	CONFIG_SND_SOC_MODULE_OVERLAY_RK3308=m

#modVer = $(shell ls $(TARGET_DIR)/lib/modules/ | xargs basename)
define EXAMPLE_MODULE_OVERLAY_INSTALL_MOD
#	$(INSTALL) -D -m 644 $(@D)/$(EXAMPLE_MODULE_OVERLAY_MODULE_SUBDIRS)/snd-soc-module-overlay-rk3308.ko \
		$(TARGET_DIR)/lib/modules/${modVer}/kernel/sound/soc/rockchip/snd-soc-module-overlay-rk3308.ko

	mkdir -p ${BINARIES_DIR}/rockchip/overlays
	$(INSTALL) -D -m 644 $(@D)/$(EXAMPLE_MODULE_OVERLAY_MODULE_SUBDIRS)/module-overlay-rk3308.dtbo ${BINARIES_DIR}/rockchip/overlays/
endef
EXAMPLE_MODULE_OVERLAY_POST_INSTALL_TARGET_HOOKS += EXAMPLE_MODULE_OVERLAY_INSTALL_MOD

$(eval $(kernel-module))
$(eval $(generic-package))
