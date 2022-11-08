################################################################################
#
# example-module-overlay
#
################################################################################

DUMMY_SOUNDCARD_VERSION = 0.0.1
DUMMY_SOUNDCARD_SITE = $(BR2_EXTERNAL)/package/dummy-soundcard
DUMMY_SOUNDCARD_SITE_METHOD = local
DUMMY_SOUNDCARD_DEPENDENCIES =

DUMMY_SOUNDCARD_MODULE_SUBDIRS = module-dummy-soundcard
DUMMY_SOUNDCARD_MODULE_MAKE_OPTS = \
	INSTALL_MOD_DIR=kernel/sound/soc/rockchip \
	CONFIG_SND_SOC_DUMMY_SOUNDCARD=m

define DUMMY_SOUNDCARD_INSTALL_MOD
	mkdir -p ${BINARIES_DIR}/rockchip/overlays
	$(INSTALL) -D -m 644 $(@D)/$(DUMMY_SOUNDCARD_MODULE_SUBDIRS)/dummy-soundcard.dtbo ${BINARIES_DIR}/rockchip/overlays/
endef
DUMMY_SOUNDCARD_POST_INSTALL_TARGET_HOOKS += DUMMY_SOUNDCARD_INSTALL_MOD

$(eval $(kernel-module))
$(eval $(generic-package))
