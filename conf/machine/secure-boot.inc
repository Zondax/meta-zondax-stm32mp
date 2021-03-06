# Enable bootloader verification
TF_A_SIGN_ENABLE ?= "1"
#BL2_SIGN_ENABLE ?= "1"
TF_A_GENERATE_KEYS ?= "1"
TF_A_SIGN_KEYNAME ?= "root"
TF_A_SIGN_KEYDIR ?= "${TOPDIR}/keys"
TF_A_SIGN_KEY_PASS ?= "dummy"

# Enable kernel verification
FIT_GENERATE_KEYS ?= "1"
FIT_SIGN_INDIVIDUAL ?= "1"
UBOOT_SIGN_ENABLE ?= "1"
UBOOT_SIGN_KEYNAME ?= "kernel-fit-conf"
UBOOT_SIGN_IMG_KEYNAME ?= "kernel-fit-image"
UBOOT_SIGN_KEYDIR ?= "${TOPDIR}/keys"
UBOOT_MKIMAGE_DTCOPTS ?= "-I dts -O dtb -p 0x1000"
