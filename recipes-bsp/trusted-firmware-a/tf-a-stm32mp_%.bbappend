DEPENDS += "openssl-native"

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
