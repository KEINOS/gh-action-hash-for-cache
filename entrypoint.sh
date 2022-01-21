#!/bin/sh -l

# Get path and variant from the inputs
PATHS="${1}"
echo "::debug:: PATHS: ${PATHS}"

VARIANT="${2}"
echo "::debug:: VARIANT: ${VARIANT}"

# File hashing by path iteration.
result=""
for path in $PATHS; do
    if [ -e "$path" ]; then
        # Hash the current file
        hashTmp="$(sha512sum "${path}" | cut -d ' ' -f 1)"
        echo "::debug:: [File]: ${path} --> [SHA512]: ${hashTmp}"

        # Stretching (re-hash with previous hash as salt)
        result=$(echo -n "${hashTmp}${result}" | openssl sha512 | cut -d ' ' -f 2)
        echo "::debug:: Current hash: ${result}"
    else
        echo >&2 "File does not exist: ${path}"
        exit 1
    fi
done

# It hashes the variant so that it can accept any string.
variant=$(echo -n "${VARIANT}" | openssl sha512 | cut -d ' ' -f 2)

# Final hash with the variant
HASHED="${result:0:32}:${variant:0:16}"

# Expose the final output
echo "::debug:: Final hash with variant: ${HASHED}"
echo "::set-output name=hash::${HASHED}"
echo "Final hash: ${HASHED}"
