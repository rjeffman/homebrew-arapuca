#!/usr/bin/env bash
# Helper script to update the Homebrew formula for a new release
# Usage: ./scripts/update-homebrew-formula.sh <version>

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 0.2.1"
    exit 1
fi

VERSION="$1"
FORMULA_FILE="Formula/arapuca.rb"
TARBALL_URL="https://github.com/sergio-correia/arapuca/archive/refs/tags/v${VERSION}.tar.gz"
TEMP_FILE=$(mktemp)

echo "Downloading tarball for version ${VERSION}..."
curl -sL "${TARBALL_URL}" -o "${TEMP_FILE}"

echo "Calculating SHA256..."
if command -v sha256sum &> /dev/null; then
    SHA256=$(sha256sum "${TEMP_FILE}" | cut -d' ' -f1)
elif command -v shasum &> /dev/null; then
    SHA256=$(shasum -a 256 "${TEMP_FILE}" | cut -d' ' -f1)
else
    echo "Error: Neither sha256sum nor shasum found"
    rm "${TEMP_FILE}"
    exit 1
fi

rm "${TEMP_FILE}"

echo ""
echo "Version: ${VERSION}"
echo "SHA256:  ${SHA256}"
echo ""

if [ ! -f "${FORMULA_FILE}" ]; then
    echo "Error: Formula file not found: ${FORMULA_FILE}"
    exit 1
fi

# Update the formula
sed -i.bak \
    -e "s|url \".*\"|url \"${TARBALL_URL}\"|" \
    -e "s|sha256 \".*\"|sha256 \"${SHA256}\"|" \
    "${FORMULA_FILE}"

rm "${FORMULA_FILE}.bak"

echo "Updated ${FORMULA_FILE}"
echo ""
echo "Next steps:"
echo "1. Review the changes: git diff ${FORMULA_FILE}"
echo "2. Test the formula: brew install --build-from-source ${FORMULA_FILE}"
echo "3. Commit: git add ${FORMULA_FILE} && git commit -s -m 'Update arapuca to ${VERSION}'"
echo "4. Push to your homebrew-arapuca tap repository"
