################################################################################
#
# GTKIOSTREAM
#
################################################################################
GTKIOSTREAM_VERSION = HEAD
GTKIOSTREAM_SITE = $(call github,flatmax,gtkiostream,$(GTKIOSTREAM_VERSION))
GTKIOSTREAM_LICENSE = GPLv2
GTKIOSTREAM_INSTALL_STAGING = YES
GTKIOSTREAM_INSTALL_TARGET = YES
GTKIOSTREAM_CONF_OPTS = --disable-octave
GTKIOSTREAM_DEPENDENCIES = libsamplerate eigen fftw-double fftw-single alsa-utils libsox

GTKIOSTREAM_AUTORECONF = YES

define GTKIOSTREAM_M4
  pushd $(@D); ./tools/autotoolsClean.sh;	popd
	cd $(@D) ; mkdir -p m4
endef

GTKIOSTREAM_PRE_CONFIGURE_HOOKS += GTKIOSTREAM_M4

$(eval $(autotools-package))
