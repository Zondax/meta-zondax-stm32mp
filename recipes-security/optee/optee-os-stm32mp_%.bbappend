FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-plat-stm32mp1-enable-stack-unwinding.patch \
            file://0002-plat-stm32mp1-enable-BSEC-write-capabilities.patch \
            "

EXTRA_OEMAKE  += "${@bb.utils.contains('ENABLE_TA_SIGNING', '1', 'TA_PUBLIC_KEY=${TA_CUSTOM_PUBKEY}', '', d)}"
