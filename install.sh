#!/bin/bash
#
# git-worth installer for Linux and macOS
# Usage: curl -fsSL <url>/install.sh | bash
#        or: ./install.sh
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔════════════════════════════════════════╗"
echo "║       💰 git-worth installer           ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"

# Check for Python 3
echo -e "${YELLOW}Checking for Python 3...${NC}"

PYTHON_CMD=""
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    # Check if python is Python 3
    if python --version 2>&1 | grep -q "Python 3"; then
        PYTHON_CMD="python"
    fi
fi

if [ -z "$PYTHON_CMD" ]; then
    echo -e "${RED}❌ Python 3 is required but not installed.${NC}"
    echo ""
    echo "Please install Python 3:"
    echo ""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "  macOS:  brew install python3"
        echo "     or:  https://www.python.org/downloads/"
    else
        echo "  Ubuntu/Debian:  sudo apt install python3"
        echo "  Fedora:         sudo dnf install python3"
        echo "  Arch:           sudo pacman -S python"
        echo "     or:          https://www.python.org/downloads/"
    fi
    exit 1
fi

PYTHON_VERSION=$($PYTHON_CMD --version 2>&1)
echo -e "${GREEN}✓ Found $PYTHON_VERSION${NC}"

# Determine install directory
INSTALL_DIR=""
if [ -d "$HOME/.local/bin" ]; then
    INSTALL_DIR="$HOME/.local/bin"
elif [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
else
    # Create ~/.local/bin if it doesn't exist
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
fi

echo -e "${YELLOW}Installing to: $INSTALL_DIR${NC}"

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_FILE="$SCRIPT_DIR/git-worth.py"

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${RED}❌ Cannot find git-worth.py${NC}"
    echo "   Make sure you're running this from the git-worth directory."
    exit 1
fi

# Copy the script
cp "$SOURCE_FILE" "$INSTALL_DIR/git-worth"
chmod +x "$INSTALL_DIR/git-worth"

echo -e "${GREEN}✓ Installed git-worth${NC}"

# Check if install dir is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo -e "${YELLOW}⚠️  $INSTALL_DIR is not in your PATH${NC}"
    echo ""
    echo "Add it by running:"
    echo ""
    
    SHELL_NAME=$(basename "$SHELL")
    case "$SHELL_NAME" in
        zsh)
            echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc"
            echo "  source ~/.zshrc"
            ;;
        bash)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bash_profile"
                echo "  source ~/.bash_profile"
            else
                echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
                echo "  source ~/.bashrc"
            fi
            ;;
        *)
            echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
            echo "  (Add this to your shell's config file)"
            ;;
    esac
    echo ""
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Installation complete!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
echo "Usage: Navigate to any git repository and run:"
echo ""
echo -e "  ${CYAN}git-worth${NC}"
echo ""
echo "Happy building! 🚀"
echo ""







