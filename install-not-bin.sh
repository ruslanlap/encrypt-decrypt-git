#!/bin/bash

# Define variables
SCRIPT_NAME="encrypt.sh"
SCRIPT_URL="https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git-python/master/encrypt.sh"
DESTINATION_DIR="$HOME/bin"
DESTINATION_PATH="$DESTINATION_DIR/cryptonit"

# Expected checksum for encrypt.sh (updated for interactive version)
EXPECTED_CHECKSUM="0c70ced091219eeb411a06b7b8438dee5641d51747e69398ddfc02e9c9177e2e"

# Color codes for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if OpenSSL is installed
check_openssl() {
    if ! command -v openssl &> /dev/null; then
        echo -e "${RED}Error: OpenSSL is not installed${NC}"
        echo "Please install OpenSSL first:"
        echo "For Ubuntu/Debian: sudo apt-get install openssl"
        echo "For CentOS/RHEL: sudo yum install openssl"
        echo "For Fedora: sudo dnf install openssl"
        exit 1
    fi
}

# Create destination directory if it doesn't exist
create_bin_dir() {
    if [ ! -d "$DESTINATION_DIR" ]; then
        echo -e "${BLUE}Creating directory $DESTINATION_DIR${NC}"
        mkdir -p "$DESTINATION_DIR"
    fi
}

verify_checksum() {
    local file=$1
    local expected=$2
    local computed=$(sha256sum "$file" | cut -d' ' -f1)
    
    echo -e "${BLUE}Verifying checksum for $file...${NC}"
    echo -e "${BLUE}Computed checksum: $computed${NC}"
    echo -e "${BLUE}Expected checksum: $expected${NC}"
    
    if [ "$computed" != "$expected" ]; then
        echo -e "${RED}❌ Checksum verification failed!${NC}"
        echo -e "${RED}Security Error: The downloaded file may have been tampered with.${NC}"
        echo -e "${RED}Installation aborted for security reasons.${NC}"
        rm -f "$file"
        exit 1
    fi
    echo -e "${GREEN}✅ Checksum verification successful!${NC}"
}

# Function to download and verify files
download_files() {
    echo -e "${BLUE}Downloading '$SCRIPT_NAME'...${NC}"
    if ! curl -sSLo "$SCRIPT_NAME" "$SCRIPT_URL"; then
        echo -e "${RED}Failed to download $SCRIPT_NAME${NC}"
        exit 1
    fi
    echo -e "${GREEN}Download complete!${NC}"
    
    # Verify encrypt.sh checksum
    verify_checksum "$SCRIPT_NAME" "$EXPECTED_CHECKSUM"
}

# Install the scripts
install_scripts() {
    echo -e "${BLUE}Installing scripts to $DESTINATION_DIR...${NC}"
    
    # Copy encrypt.sh as cryptonit
    cp "$SCRIPT_NAME" "$DESTINATION_PATH"
    
    # Make script executable
    chmod +x "$DESTINATION_PATH"
    
    echo -e "${GREEN}✅ Installation successful!${NC}"
}

# Update PATH if needed
update_path() {
    if [[ ":$PATH:" != *":$DESTINATION_DIR:"* ]]; then
        echo -e "${BLUE}Adding $DESTINATION_DIR to PATH${NC}"
        
        # Add to .bashrc if it exists
        if [ -f "$HOME/.bashrc" ]; then
            echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
        fi
        
        # Add to .zshrc if it exists
        if [ -f "$HOME/.zshrc" ]; then
            echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.zshrc"
        fi
        
        # Add to .profile if it exists
        if [ -f "$HOME/.profile" ]; then
            echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.profile"
        fi
        
        echo -e "${GREEN}✅ PATH updated${NC}"
        echo "Please restart your terminal or run: source ~/.bashrc"
    fi
}

# Cleanup temporary files
cleanup() {
    rm -f "$SCRIPT_NAME"
}

# Main installation process
main() {
    echo -e "${BLUE}Starting CRYPTONIT installation...${NC}"
    
    check_openssl
    create_bin_dir
    download_files
    install_scripts
    update_path
    cleanup
    
    echo -e "\n${GREEN}✅ CRYPTONIT installation completed!${NC}"
    echo -e "${BLUE}Usage:${NC}"
    echo "1. Restart your terminal or run: source ~/.bashrc"
    echo "2. Run 'cryptonit' to start the encryption/decryption tool"
    echo "   Example: cryptonit encrypt secret.txt"
    echo "   Example: cryptonit decrypt secret.txt_crypt"
}

# Run main installation
main
