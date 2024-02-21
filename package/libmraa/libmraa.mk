################################################################################
#
# libmraa
#
################################################################################

# MRAA_VERSION = 3c288a09109969eef9c2da7d92d3c62f92a015cc -- FOR OFFICIAL ECLIPSE/MRAA
LIBMRAA_VERSION = df94ff947f4034498ae1c747032c35505d9f0a84 # RADXA (YUNTIAN) DOWNSTREAM MRAA
# MRAA_SITE = https://github.com/eclipse/mraa.git
LIBMRAA_SITE = https://github.com/RadxaYuntian/mraa.git
LIBMRAA_SITE_METHOD = git
LIBMRAA_LICENSE = MIT
LIBMRAA_LICENSE_FILES = COPYING
LIBMRAA_INSTALL_STAGING = YES

ifeq ($(BR2_i386),y)
LIBMRAA_ARCH = i386
else ifeq ($(BR2_x86_64),y)
LIBMRAA_ARCH = x86_64
else ifeq ($(BR2_arm)$(BR2_armeb),y)
LIBMRAA_ARCH = arm
else ifeq ($(BR2_aarch64)$(BR2_aarch64_be),y)
LIBMRAA_ARCH = aarch64
else ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
LIBMRAA_ARCH = mips
endif

# USBPLAT only makes sense with FTDI4222, which requires the ftd2xx library,
# which doesn't exist in buildroot
# Disable C++ as it is used only by FTDI4222 and tests
LIBMRAA_CONF_OPTS += \
	-DBUILDARCH=$(LIBMRAA_ARCH) \
	-DBUILDCPP=OFF \
	-DBUILDSWIG=OFF \
	-DUSBPLAT=OFF \
	-DFTDI4222=OFF \
	-DENABLEEXAMPLES=OFF \
	-DBUILDTESTS=OFF

ifeq ($(BR2_PACKAGE_JSON_C),y)
LIBMRAA_CONF_OPTS += -DJSONPLAT=ON
LIBMRAA_DEPENDENCIES += json-c
else
LIBMRAA_CONF_OPTS += -DJSONPLAT=OFF
endif

$(eval $(cmake-package))
