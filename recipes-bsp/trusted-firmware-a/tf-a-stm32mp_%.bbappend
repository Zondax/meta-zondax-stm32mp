FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://sign_image.py \
            file://make_hash.py \
            "

DEPENDS += "openssl-native python3-pycryptodomex-native"

inherit python3native

FIP_SIGN_KEY = "${FIP_SIGN_KEYDIR}/${FIP_SIGN_KEYNAME}.pem"

do_deploy:prepend() {
    if [ "${TF_A_SIGN_ENABLE}" = "1" ]; then
        if [ "${FIP_GENERATE_KEYS}" = "1" ]; then
            # Generate keys to sign configuration nodes, only if they don't already exist
            if [ ! -f "${FIP_SIGN_KEYDIR}/${FIP_SIGN_KEYNAME}".pem ]; then
                # make directory if it does not already exist
                mkdir -p "${FIP_SIGN_KEYDIR}"

                echo "Generating ECDSA private key for signing FIP binary"
                openssl ecparam -name prime256v1 -genkey \
                    -out "${FIP_SIGN_KEYDIR}/${FIP_SIGN_KEYNAME}".pem
            fi
        fi
    fi
}

do_deploy:append() {
    if [ "${TF_A_SIGN_ENABLE}" = "1" ]; then
        BL2_DIRECTORY="${DEPLOYDIR}/arm-trusted-firmware"

        bin_file="${BL2_DIRECTORY}/public-key-hash.bin"
        ${PYTHON} "${WORKDIR}/make_hash.py" "$bin_file" \
            "${FIP_SIGN_KEY}" "${FIP_SIGN_KEY_PASS}"

        for img_file in "${BL2_DIRECTORY}/"*".${TF_A_SUFFIX}"; do
            [ -e "$img_file" ] || continue
            ${PYTHON} "${WORKDIR}/sign_image.py" "$img_file" \
                "${FIP_SIGN_KEY}" "${FIP_SIGN_KEY_PASS}"
        done
    fi
}
