################################################################################
#
# usb-bridge package
#
################################################################################

USB_BRIDGE_VERSION = 0.0.1
USB_BRIDGE_LICENSE = GPL-3.0+
USB_BRIDGE_SITE = $(BR2_EXTERNAL)/package/usb-bridge/scripts
USB_BRIDGE_SITE_METHOD = local
USB_BRIDGE_STAGING=YES

define USB_BRIDGE_INSTALL_TARGET_CMDS
	cp $(@D)/S41-start-bridge $(TARGET_DIR)/etc/init.d/
	chmod 555 $(TARGET_DIR)/etc/init.d/S41-start-bridge
endef

$(eval $(generic-package))
