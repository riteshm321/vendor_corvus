# Don't build debug for host or device
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
ART_BUILD_TARGET_NDEBUG := true
ART_BUILD_TARGET_DEBUG := false
ART_BUILD_HOST_NDEBUG := true
ART_BUILD_HOST_DEBUG := false
USE_DEX2OAT_DEBUG := false

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Google Play services configuration
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent

PRODUCT_PACKAGES += \
    NetworkStackOverlay

# Additional props
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.debug.alloc=0 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.dataroaming=false \
    media.recorder.show_manufacturer_and_model=true \
    ro.opa.eligible_device=true \
    drm.service.enabled=true \
    media.mediadrmservice.enable=true \
    net.tethering.noprovisioning=true \
    keyguard.no_require_sim=true \
    persist.sys.disable_rescue=true \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0 \
    ro.input.video_enabled=false \
    ro.setupwizard.enterprise_mode=1 \
    setupwizard.feature.predeferred_enabled=false \
    ro.setupwizard.mode=OPTIONAL

# SystemUI
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

PRODUCT_PROPERTY_OVERRIDES += \
    pm.dexopt.boot=verify \
    pm.dexopt.first-boot=verify \
    pm.dexopt.install=speed-profile \
    pm.dexopt.bg-dexopt=everything

# IORap app launch prefetching using Perfetto traces and madvise
PRODUCT_PRODUCT_PROPERTIES += \
    ro.iorapd.enable=true

PRODUCT_SYSTEM_PROPERTIES += \
    persist.device_config.runtime_native_boot.iorap_perfetto_enable=true

# Gapps
ifeq ($(USE_GAPPS), true)
$(call inherit-product, vendor/gapps/common/common-vendor.mk)

PRODUCT_COPY_FILES += \
$(call find-copy-subdir-files,*,vendor/corvus/prebuilt/product/usr/,$(TARGET_COPY_OUT_PRODUCT)/usr)
endif

# StorageManager configuration
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=1 \
    ro.storage_manager.show_opt_in=false

# Blurs
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
    
# Disable blur on app-launch
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.launcher.blur.appLaunch=false

# Disable remote keyguard animation
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.wm.enable_remote_keyguard_animation=0

# Disable async MTE on system_server
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    arm64.memtag.process.system_server=off

# Don't preopt prebuilts
DONT_DEXPREOPT_PREBUILTS := true

# Enable dex2oat64 to do dexopt
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    dalvik.vm.dex2oat64.enabled=true

# Set cache location
ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/data/cache
else
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/cache
endif

# Proton Clang
ifeq ($(USE_CUSTOM_CLANG),true)
KERNEL_SUPPORTS_LLVM_TOOLS := true
TARGET_KERNEL_CLANG_COMPILE := true
TARGET_KERNEL_CLANG_VERSION := 15
TARGET_KERNEL_ADDITIONAL_FLAGS += LLVM=1 LLVM_IAS=1
TARGET_KERNEL_CLANG_PATH := $(shell pwd)/prebuilts/clang/host/linux-x86/weebx-clang
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-gnu-
endif

# Copy all custom init rc files
$(foreach f,$(wildcard vendor/corvus/prebuilt/common/etc/init/*.rc),\
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# init
PRODUCT_COPY_FILES += \
    vendor/corvus/prebuilt/common/etc/init/init.corvus-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.corvus-system_ext.rc

# Permission
PRODUCT_COPY_FILES += \
    vendor/corvus/prebuilt/common/etc/permissions/corvus-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/corvus-power-whitelist.xml \
    vendor/corvus/prebuilt/common/etc/init/smartcharge-init.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/smartcharge-init.rc \
    vendor/corvus/prebuilt/common/etc/permissions/privapp-permissions-settings.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-settings.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# Backup tool
PRODUCT_COPY_FILES += \
    vendor/corvus/build/tools/backuptool.sh:install/bin/backuptool.sh \
    vendor/corvus/build/tools/backuptool.functions:install/bin/backuptool.functions \
    vendor/corvus/build/tools/50-corvus.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-corvus.sh

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Skip boot JAR checks.
SKIP_BOOT_JARS_CHECK := true

# Enable ccache
USE_CCACHE := true

# Flatten APEXs for performance
OVERRIDE_TARGET_FLATTEN_APEX := true
# This needs to be specified explicitly to override ro.apex.updatable=true from
# # prebuilt vendors, as init reads /product/build.prop after /vendor/build.prop
PRODUCT_PRODUCT_PROPERTIES += ro.apex.updatable=false

# Boot animation
include vendor/corvus/config/bootanimation.mk

# Branding
include vendor/corvus/config/branding.mk

# Packages
include vendor/corvus/config/packages.mk

# Overlays
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/corvus/overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/corvus/overlay/common

# Copy all init rc files
$(foreach f,$(wildcard vendor/corvus/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= true
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    FaceUnlockService
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face_unlock_service.enabled=$(TARGET_FACE_UNLOCK_SUPPORTED)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Enable gestural navigation overlay to match default navigation mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    Settings

# Spoof fingerprint for Google Play Services and SafetyNet
ifeq ($(PRODUCT_OVERRIDE_GMS_FINGERPRINT),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.build.gms_fingerprint=google/walleye/walleye:8.1.0/OPM1.171019.011/4448085:user/release-keys
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.build.gms_fingerprint=$(PRODUCT_OVERRIDE_GMS_FINGERPRINT)
endif
