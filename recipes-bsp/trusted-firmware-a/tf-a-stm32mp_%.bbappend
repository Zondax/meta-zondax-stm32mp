FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://sign_image.py \
            file://make_hash.py \
            "

DEPENDS += "openssl-native python3-pycryptodomex-native"

inherit python3native

BL2_SIGN_ENABLE ?= "0"

TF_A_GENERATE_KEYS ?= "0"

TF_A_SIGN_KEYNAME ?= ""
TF_A_SIGN_KEYDIR ?= ""

TF_A_SIGN_KEY = "${TF_A_SIGN_KEYDIR}/${TF_A_SIGN_KEYNAME}.pem"
TF_A_SIGN_KEY_PASS ?= ""

FIP_SIGN_KEY = "${TF_A_SIGN_KEY}"
FIP_SIGN_KEY_PASS = "${TF_A_SIGN_KEY_PASS}"

KEY_HASH_FILE = "${B}/public-key-hash.bin"

do_install:append() {
    if [ "${TF_A_SIGN_ENABLE}" = "1" ]; then
        if [ "${TF_A_GENERATE_KEYS}" = "1" ]; then
            # Make directory if it does not already exist
            mkdir -p "${TF_A_SIGN_KEYDIR}"

            # Generate key to sign BL2 and FIP binaries
            if [ ! -f "${TF_A_SIGN_KEY}" ]; then
                echo "Generating ECDSA private key for signing BL2 and FIP"
                openssl genpkey -algorithm ec \
                    -pkeyopt ec_paramgen_curve:prime256v1 \
                    -aes-256-cbc -pass pass:"${TF_A_SIGN_KEY_PASS}" \
                    -out "${TF_A_SIGN_KEY}"
            fi
        fi

        if [ "${BL2_SIGN_ENABLE}" = "1" ]; then
            ${PYTHON} "${WORKDIR}/make_hash.py" "${KEY_HASH_FILE}" \
                "${TF_A_SIGN_KEY}" "${TF_A_SIGN_KEY_PASS}"

            install -d ${D}/boot
            install -m 644 ${KEY_HASH_FILE} ${D}/boot
        fi
    fi
}

do_deploy:append() {
    if [ "${TF_A_SIGN_ENABLE}" = "1" ]; then
        if [ "${BL2_SIGN_ENABLE}" = "1" ]; then
            BL2_DIRECTORY="${DEPLOYDIR}/arm-trusted-firmware"

            for img_file in "${BL2_DIRECTORY}/"*".${TF_A_SUFFIX}"; do
                [ -e "$img_file" ] || continue
                ${PYTHON} "${WORKDIR}/sign_image.py" "$img_file" \
                    "${TF_A_SIGN_KEY}" "${TF_A_SIGN_KEY_PASS}"
            done
        fi
    fi
}

ALLOW_EMPTY:${PN} = "1"
FILES:${PN} = "/boot"
