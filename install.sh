#!/bin/bash
# Chunk CLI — one-line installer
# curl -fsSL https://raw.githubusercontent.com/jishenjason-cmd/chunk-releases/main/install.sh | bash
set -e

BOLD="\033[1m"; GRN="\033[0;32m"; NC="\033[0m"
echo -e "\n  ${BOLD}Chunk CLI Installer${NC}\n"

VERSION="${CHUNK_VERSION:-2.1.88}"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed 's/x86_64/amd64/' | sed 's/aarch64/arm64/')"
INSTALL_DIR="$HOME/.local/share/chunk/$VERSION"
BIN_DIR="$INSTALL_DIR/chunk/bin"
TARBALL="chunk-v${VERSION}-${OS}-${ARCH}.tar.gz"
RELEASES_URL="https://github.com/jishenjason-cmd/chunk-releases/releases/download/v${VERSION}/${TARBALL}"

# Already installed?
if [ -f "$BIN_DIR/chunk" ]; then
  echo -e "  ${GRN}✓${NC} Already installed at $INSTALL_DIR"
else
  echo -e "  → Downloading $VERSION..."
  curl -fsSL# "$RELEASES_URL" -o /tmp/chunk.tar.gz
  echo -e "  → Extracting..."
  mkdir -p "$INSTALL_DIR"
  tar xzf /tmp/chunk.tar.gz -C "$INSTALL_DIR" 2>/dev/null
  rm -f /tmp/chunk.tar.gz
  echo -e "  ${GRN}✓${NC} Installed"
fi

# PATH
SHELL_RC=""
[ -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.zshrc"
[ -f "$HOME/.bashrc" ] && SHELL_RC="$HOME/.bashrc"

if ! grep -Fq "$BIN_DIR" "$SHELL_RC" 2>/dev/null; then
  echo "# Chunk CLI" >> "$SHELL_RC"
  echo "export PATH=\"\$PATH:$BIN_DIR\"" >> "$SHELL_RC"
  echo -e "  ${GRN}✓${NC} Added to $SHELL_RC"
fi

echo ""
echo -e "  ${BOLD}Done!${NC} Run: ${GRN}source $SHELL_RC${NC} (or restart terminal)"
echo -e "  Then: ${GRN}chunk${NC}"
echo ""
echo "  Need an API key?   export DEEPSEEK_API_KEY=sk-..."
echo "  Other providers?   chunk --provider zhipu"
