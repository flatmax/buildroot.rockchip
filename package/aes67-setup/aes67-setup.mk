################################################################################
#
# aes67-setup
#
################################################################################

AES67_SETUP_VERSION = 0.1.0

AES67_SETUP_VERSION = 0.0.1
AES67_SETUP_SITE = $(BR2_EXTERNAL)/package/aes67-setup
AES67_SETUP_SITE_METHOD = local

define AES67_SETUP_INSTALL_INIT_SYSV
$(INSTALL) -m 0755 -D $(AES67_SETUP_PKGDIR)/S95-aes67 $(TARGET_DIR)/etc/init.d/
$(INSTALL) -m 0755 -D $(AES67_SETUP_PKGDIR)/S96-wireplumber $(TARGET_DIR)/etc/init.d/
endef
AES67_SETUP_POST_INSTALL_TARGET_HOOKS += AES67_SETUP_INSTALL_INIT_SYSV

$(eval $(generic-package))
