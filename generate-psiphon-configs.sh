#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$PROJECT_DIR/config/psiphon"
REGION_DIR="$CONFIG_DIR/regions"
BASE_CONFIG="$CONFIG_DIR/base.config"
CONTAINER="${PSIPHON_CONTAINER:-opencode-proxy}"

# Region yang akan dibuat
REGIONS=(
    "auto:"
    "de:DE"
    "sg:SG"
    "jp:JP"
    "us:US"
    "id:ID"
    "nl:NL"
    "gb:GB"
    "fr:FR"
)

echo "===================================="
echo " Psiphon Configuration Generator"
echo "===================================="

# Dependencies
if ! command -v jq >/dev/null 2>&1; then
    echo "ERROR: jq belum terpasang."
    echo "Install dengan: sudo pacman -S jq"
    exit 1
fi

# Create directories
mkdir -p "$REGION_DIR"

# Get base config from container if not available
if [[ ! -f "$BASE_CONFIG" ]]; then
    echo "Mengambil konfigurasi dari container: $CONTAINER"

    if ! docker cp \
        "$CONTAINER:/config/psiphon.config" \
        "$BASE_CONFIG"; then
        echo "ERROR: Tidak dapat mengambil konfigurasi Psiphon."
        exit 1
    fi

    chmod 600 "$BASE_CONFIG"
fi

# Validate JSON
if ! jq empty "$BASE_CONFIG" >/dev/null 2>&1; then
    echo "ERROR: Base configuration bukan JSON valid."
    exit 1
fi

# Validate object
if [[ "$(jq -r 'type' "$BASE_CONFIG")" != "object" ]]; then
    echo "ERROR: Root konfigurasi harus berupa JSON object."
    exit 1
fi

echo
echo "Base config: $BASE_CONFIG"
echo "Output     : $REGION_DIR"
echo

# Generate configurations
for entry in "${REGIONS[@]}"; do
    NAME="${entry%%:*}"
    REGION="${entry#*:}"

    OUTPUT="$REGION_DIR/${NAME}.config"

    jq --arg region "$REGION" \
        '.EgressRegion = $region' \
        "$BASE_CONFIG" > "$OUTPUT.tmp"

    chmod 600 "$OUTPUT.tmp"
    mv "$OUTPUT.tmp" "$OUTPUT"

    printf "Generated: %-15s EgressRegion=%s\n" \
        "$OUTPUT" "${REGION:-AUTO}"
done

echo
echo "===================================="
echo " Selesai"
echo "===================================="

echo
echo "Daftar konfigurasi:"
for file in "$REGION_DIR"/*.config; do
    REGION=$(jq -r '.EgressRegion' "$file")
    printf "%-20s %s\n" "$(basename "$file")" "${REGION:-AUTO}"
done
