#!/usr/bin/env bash
# Install cflow CLI
# Usage: curl -fsSL https://raw.githubusercontent.com/vanhiep99w/cflow/main/cli/install.sh | bash

set -euo pipefail

REPO="vanhiep99w/cflow"
BRANCH="main"
INSTALL_DIR="${HOME}/.local/bin"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Installing cflow CLI...${NC}"
echo ""

# Create install directory
mkdir -p "$INSTALL_DIR"

# Download cflow script
if command -v curl &>/dev/null; then
  curl -fsSL "https://raw.githubusercontent.com/${REPO}/${BRANCH}/cli/cflow" -o "${INSTALL_DIR}/cflow"
elif command -v wget &>/dev/null; then
  wget -q "https://raw.githubusercontent.com/${REPO}/${BRANCH}/cli/cflow" -O "${INSTALL_DIR}/cflow"
else
  echo -e "${RED}Error: curl or wget required${NC}" >&2
  exit 1
fi

chmod +x "${INSTALL_DIR}/cflow"

# Also clone/cache the full repo for skill content
CACHE_DIR="${HOME}/.cache/cflow"
echo "Caching cflow source..."

if command -v git &>/dev/null; then
  if [ -d "$CACHE_DIR/.git" ]; then
    (cd "$CACHE_DIR" && git pull --quiet origin "$BRANCH" 2>/dev/null || true)
  else
    rm -rf "$CACHE_DIR"
    git clone --quiet --depth 1 "https://github.com/${REPO}.git" "$CACHE_DIR"
  fi
else
  tmpfile=$(mktemp)
  curl -fsSL "https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz" -o "$tmpfile"
  rm -rf "$CACHE_DIR"
  mkdir -p "$CACHE_DIR"
  tar xzf "$tmpfile" -C "$CACHE_DIR" --strip-components=1
  rm -f "$tmpfile"
fi

echo ""
echo -e "${GREEN}Installed!${NC}"
echo ""
echo "  cflow installed to: ${INSTALL_DIR}/cflow"
echo ""

# Check if install dir is in PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo -e "${RED}Warning:${NC} ${INSTALL_DIR} is not in your PATH."
  echo ""
  echo "Add it to your shell profile:"
  echo ""
  echo "  # For bash (~/.bashrc):"
  echo "  export PATH=\"\${HOME}/.local/bin:\${PATH}\""
  echo ""
  echo "  # For zsh (~/.zshrc):"
  echo "  export PATH=\"\${HOME}/.local/bin:\${PATH}\""
  echo ""
fi

echo "Usage:"
echo "  cd your-project"
echo "  cflow init       # Install skills"
echo "  cflow list       # List installed skills"
echo "  cflow update     # Update to latest"
