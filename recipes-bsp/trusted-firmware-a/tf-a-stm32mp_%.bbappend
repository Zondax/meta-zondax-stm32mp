FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://sign_image.py \
            file://make_hash.py \
            "

DEPENDS += "openssl-native python3-pycryptodomex-native"

inherit python3native

FIP_SIGN_KEY = "${FIP_SIGN_KEYDIR}/${FIP_SIGN_KEYNAME}.pem"

KEY_HASH_FILE = "${B}/public-key-hash.bin"

do_install:append() {
    if [ "${TF_A_SIGN_ENABLE}" = "1" ]; then
        if [ "${FIP_GENERATE_KEYS}" = "1" ]; then
            # Generate keys to sign BL2 and FIP binaries
            if [ ! -f "${FIP_SIGN_KEYDIR}/${FIP_SIGN_KEYNAME}".pem ]; then
                # make directory if it does not already exist
                mkdir -p "${FIP_SIGN_KEYDIR}"

                echo "Generating ECDSA private key for signing BL2 and FIP"
                openssl ecparam -name prime256v1 -genkey \
                    -out "${FIP_SIGN_KEYDIR}/${FIP_SIGN_KEYNAME}".pem
            fi
        fi

        ${PYTHON} "${WORKDIR}/make_hash.py" "${KEY_HASH_FILE}" \
            "${FIP_SIGN_KEY}" "${FIP_SIGN_KEY_PASS}"

        install -d ${D}/boot
        install -m 644 ${KEY_HASH_FILE} ${D}/boot
    fi
}

do_deploy:append() {
    if [ "${TF_A_SIGN_ENABLE}" = "1" ]; then
        BL2_DIRECTORY="${DEPLOYDIR}/arm-trusted-firmware"

        for img_file in "${BL2_DIRECTORY}/"*".${TF_A_SUFFIX}"; do
            [ -e "$img_file" ] || continue
            ${PYTHON} "${WORKDIR}/sign_image.py" "$img_file" \
                "${FIP_SIGN_KEY}" "${FIP_SIGN_KEY_PASS}"
        done
    fi
}

ALLOW_EMPTY:${PN} = "1"
FILES:${PN} = "/boot"
