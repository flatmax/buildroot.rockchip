################################################################################
#
# RTK_HCIATTACH
#
################################################################################
RTK_HCIATTACH_VERSION = HEAD
RTK_HCIATTACH_SITE = $(call github,radxa,rkwifibt,$(RTK_HCIATTACH_VERSION))
RTK_HCIATTACH_LICENSE = GPLv2
RTK_HCIATTACH_INSTALL_TARGET = YES

define RTK_HCIATTACH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/realtek/rtk_hciattach/rtk_hciattach $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0600 $(@D)/realtek/RTL8723DS/rtl8723d_fw $(TARGET_DIR)/lib/firmware/rtlbt
	$(INSTALL) -D -m 0600 $(@D)/realtek/RTL8723DS/rtl8723d_config $(TARGET_DIR)/lib/firmware/rtlbt
endef

define RTK_HCIATTACH_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/realtek/rtk_hciattach
endef

$(eval $(generic-package))
