################################################################################
#
# sox
#
################################################################################

LIBSOX_VERSION = 14.4.2
LIBSOX_SITE = http://downloads.sourceforge.net/project/sox/sox/$(LIBSOX_VERSION)
LIBSOX_SOURCE = sox-$(LIBSOX_VERSION).tar.bz2
#LIBSOX_DEPENDENCIES = host-pkgconf
LIBSOX_CONF_OPTS = --with-distro="Buildroot" --without-ffmpeg --disable-gomp \
	$(if $(BR2_TOOLCHAIN_HAS_SSP),,--disable-stack-protector)
LIBSOX_LICENSE = GPLv2+ (sox binary), LGPLv2.1+ (libraries)
LIBSOX_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL
LIBSOX_INSTALL_STAGING = YES

FLAC_AUTORECONF = YES


# MIPS Codescape toolchains don't support stack-smashing protection
# despite of using glibc.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESCAPE_IMG_MIPS)$(BR2_TOOLCHAIN_EXTERNAL_CODESCAPE_MTI_MIPS),y)
LIBSOX_CONF_OPTS += --disable-stack-protector
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB_PCM),y)
LIBSOX_DEPENDENCIES += alsa-lib
else
LIBSOX_CONF_OPTS += --without-alsa
endif

ifeq ($(BR2_PACKAGE_FILE),y)
LIBSOX_DEPENDENCIES += file
else
LIBSOX_CONF_OPTS += --without-magic
endif

ifeq ($(BR2_PACKAGE_FLAC),y)
LIBSOX_DEPENDENCIES += flac
else
LIBSOX_CONF_OPTS += --without-flac
endif

ifeq ($(BR2_PACKAGE_LAME),y)
LIBSOX_DEPENDENCIES += lame
else
LIBSOX_CONF_OPTS += --without-lame
endif

ifeq ($(BR2_PACKAGE_LIBAO),y)
LIBSOX_DEPENDENCIES += libao
else
LIBSOX_CONF_OPTS += --without-ao
endif

ifeq ($(BR2_PACKAGE_LIBID3TAG),y)
LIBSOX_DEPENDENCIES += libid3tag
else
LIBSOX_CONF_OPTS += --without-id3tag
endif

ifeq ($(BR2_PACKAGE_LIBMAD),y)
LIBSOX_DEPENDENCIES += libmad
else
LIBSOX_CONF_OPTS += --without-mad
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LIBSOX_DEPENDENCIES += libpng
else
LIBSOX_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
LIBSOX_DEPENDENCIES += libsndfile
else
LIBSOX_CONF_OPTS += --without-sndfile
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
LIBSOX_DEPENDENCIES += libvorbis
else
LIBSOX_CONF_OPTS += --without-oggvorbis
endif

ifeq ($(BR2_PACKAGE_OPENCORE_AMR),y)
LIBSOX_DEPENDENCIES += opencore-amr
else
LIBSOX_CONF_OPTS += --without-amrwb --without-amrnb
endif

ifeq ($(BR2_PACKAGE_OPUSFILE),y)
LIBSOX_DEPENDENCIES += opusfile
else
LIBSOX_CONF_OPTS += --without-opus
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
LIBSOX_DEPENDENCIES += pulseaudio
else
LIBSOX_CONF_OPTS += --without-pulseaudio
endif

ifeq ($(BR2_PACKAGE_TWOLAME),y)
LIBSOX_DEPENDENCIES += twolame
else
LIBSOX_CONF_OPTS += --without-twolame
endif

ifeq ($(BR2_PACKAGE_WAVPACK),y)
LIBSOX_DEPENDENCIES += wavpack
else
LIBSOX_CONF_OPTS += --without-wavpack
endif

$(eval $(autotools-package))

