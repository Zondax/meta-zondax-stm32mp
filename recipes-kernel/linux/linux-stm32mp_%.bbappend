FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-drm-stm-unblank-display-after-probe.patch \
            file://enable-fbdev-emulation.cfg \
            "

KERNEL_CONFIG_FRAGMENTS += "${WORKDIR}/enable-fbdev-emulation.cfg"

UBOOT_DTB_BINARY = ""
