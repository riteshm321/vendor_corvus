ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    adb_root
endif

# Packages
PRODUCT_PACKAGES += \
    Corvus-Themes \
    LiveWallpapers \
    LiveWallpapersPicker \
    messaging \
    WallpaperPicker2 \
    TouchGestures \
    StitchImage \
    StitchImageService \
    SystemPitchBlackOverlay \
    SystemUIPitchBlackOverlay \
    SystemDarkGrayOverlay \
    SystemUIDarkGrayOverlay \
    SystemStyleOverlay \
    SystemUIStyleOverlay \
    SystemNightOverlay \
    SystemUINightOverlay \
    CustomDoze \
    CorvusWalls \
    CustomFonts

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Allows registering device to Google easier for gapps
# Integrates package for easier Google Pay fixing
PRODUCT_PACKAGES += \
    sqlite3 \
    ThemePicker

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Flipendo
PRODUCT_PACKAGES += \
    Flipendo

