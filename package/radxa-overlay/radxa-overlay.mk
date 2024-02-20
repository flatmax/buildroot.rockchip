################################################################################
#
# radxa overlays
#
################################################################################

RADXA_OVERLAYS_VERSION = 75a51f3eb025fb067aad6a80b34fa1d531277ce3
RADXA_OVERLAYS_SITE = https://github.com/radxa/overlays.git
RADXA_OVERLAYS_SITE_METHOD = git
RADXA_OVERLAYS_INSTALL_IMAGES = YES

$(eval $(generic-package))