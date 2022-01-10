include conf/machine/include/st-machine-common-stm32mp.inc
include conf/machine/include/st-machine-providers-stm32mp.inc

# Define specific familly common machine name
MACHINEOVERRIDES .= ":stm32mp1common"

# =========================================================================
# Chip architecture
# =========================================================================
DEFAULTTUNE = "cortexa7thf-neon-vfpv4"
include conf/machine/include/arm/armv7a/tune-cortexa7.inc

# =========================================================================
# boot scheme
# =========================================================================
BOOTSCHEME_LABELS += "optee"

# =========================================================================
# boot device
# =========================================================================
# Define the boot device supported
BOOTDEVICE_LABELS += "sdcard"

# =========================================================================
# Machine settings
# =========================================================================
# Define list of devicetree per board
STM32MP_DT_FILES_DK += "stm32mp157f-dk2"

# =========================================================================
# Machine features
# =========================================================================
MACHINE_FEATURES += "splashscreen"
MACHINE_FEATURES += "watchdog"
MACHINE_FEATURES += "bluetooth"
MACHINE_FEATURES += "wifi"
MACHINE_FEATURES += "m4copro"
MACHINE_FEATURES += "fit"

# Bluetooth
BLUETOOTH_LIST += "linux-firmware-bluetooth-bcm4343"
# Wifi
WIFI_LIST += "linux-firmware-bcm43430"

MACHINE_FEATURES += " ${@bb.utils.contains_any('BOOTDEVICE_LABELS',  ['emmc', 'sdcard'], 'autoresize', '', d)} "

# =========================================================================
# Kernel
# =========================================================================
# For eval board: auto-load goodix module (touchscreen module)
#KERNEL_MODULE_AUTOLOAD = "goodix"

# Define the devicetree for Linux A7 examples
LINUX_A7_EXAMPLES_DT += "stm32mp157f-dk2-a7-examples"

# =========================================================================
# M4 copro
# =========================================================================
# Define the devicetree for M4 example
CUBE_M4_EXAMPLES_DT += "stm32mp157f-dk2-m4-examples"

# Define specific board reference to use
M4_BOARDS = "STM32MP157C-DK2 STM32MP157F-DK2"

# =========================================================================
# extlinux configuration
# =========================================================================
# Set the default boot config
UBOOT_EXTLINUX_DEFAULT_LABEL_stm32mp157f-dk2 = "stm32mp157f-dk2"

# =========================================================================
# WIC for sdcard raw image
# =========================================================================
#WIC_CREATE_EXTRA_ARGS = "--no-fstab-update"
#WKS_FILE_DEPENDS ?= " \
#    virtual/bootloader \
#    virtual/trusted-firmware-a \
#    ${@bb.utils.contains('BOOTSCHEME_LABELS', 'optee', 'virtual/optee-os', '', d)} \
#    st-image-bootfs \
#    ${@bb.utils.contains('ST_VENDORFS','1','st-image-vendorfs', '', d)} \
#    st-image-userfs \
#"
#TRUSTED_WIC_FILE = "${@bb.utils.contains('ST_VENDORFS','1','sdcard-stm32mp157f-dk2-trusted-vendorfs-1GB.wks.in','sdcard-stm32mp157f-dk2-trusted-1GB.wks.in',d)}"
#OPTEE_WIC_FILE = "${@bb.utils.contains('ST_VENDORFS','1','sdcard-stm32mp157f-dk2-optee-vendorfs-1GB.wks.in','sdcard-stm32mp157f-dk2-optee-1GB.wks.in',d)}"
#
# for generated a WIC file, please uncomment the 2 following lines or add them to local.conf
#WKS_IMAGE_FSTYPES += "wic wic.bz2 wic.bmap"
#WKS_FILE += "${@bb.utils.contains('BOOTSCHEME_LABELS', 'optee', '${OPTEE_WIC_FILE}', '${TRUSTED_WIC_FILE}', d)}"