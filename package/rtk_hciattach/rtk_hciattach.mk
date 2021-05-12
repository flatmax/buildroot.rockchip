################################################################################
#
# RTK_HCIATTACH
#
################################################################################
RTK_HCIATTACH_VERSION = HEAD
#RTK_HCIATTACH_SITE = $(call github,flatmax,rtk_hciattach,$(RTK_HCIATTACH_VERSION))
RTK_HCIATTACH_SITE = $(call github,rockchip-linux,rkwifibt,$(RTK_HCIATTACH_VERSION))
# RTK_HCIATTACH_SITE = /home/flatmax/temp/rtk_hciattach
# RTK_HCIATTACH_SITE_METHOD = local
RTK_HCIATTACH_LICENSE = GPLv2
RTK_HCIATTACH_INSTALL_TARGET = YES

define RTK_HCIATTACH_INSTALL_TARGET_CMDS
   $(INSTALL) -D -m 0755 $(@D)/realtek/rtk_hciattach/rtk_hciattach $(TARGET_DIR)/usr/bin
endef

define RTK_HCIATTACH_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/realtek/rtk_hciattach
endef

$(eval $(generic-package))
