#!/bin/bash

# Define variables
SCRIPT_NAME="encrypt.sh"
SCRIPT_URL="https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git-python/master/encrypt.sh"
PYTHON_SCRIPT_URL="https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git-python/master/encrypt.py"
CHECKSUM_URL="https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git-python/master/encrypt.sh.sha256"
DESTINATION_DIR="$HOME/bin"
DESTINATION_PATH="$DESTINATION_DIR/cryptonit"

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

# Function to download and verify the checksum with progress animation
download_files() {
    echo -e "${BLUE}Downloading '$SCRIPT_NAME'...${NC}"
    if ! curl -sSLo "$SCRIPT_NAME" "$SCRIPT_URL"; then
        echo -e "${RED}Failed to download $SCRIPT_NAME${NC}"
        exit 1
    fi
    echo -e "${GREEN}Download complete!${NC}"

    echo -e "${BLUE}Downloading encrypt.py...${NC}"
    if ! curl -sSLo "encrypt.py" "$PYTHON_SCRIPT_URL"; then
        echo -e "${RED}Failed to download encrypt.py${NC}"
        exit 1
    fi
    echo -e "${GREEN}Download complete!${NC}"

    # Calculate checksum of downloaded file
    local computed_checksum=$(sha256sum "$SCRIPT_NAME" | cut -d' ' -f1)
    echo -e "${BLUE}Computed checksum: $computed_checksum${NC}"
    
    # Download and verify checksum
    echo -e "${BLUE}Downloading checksum...${NC}"
    if ! curl -sSLo "checksum.sha256" "$CHECKSUM_URL"; then
        echo -e "${RED}Failed to download checksum${NC}"
        exit 1
    fi
    
    # Extract expected checksum
    local expected_checksum=$(cat checksum.sha256 | cut -d' ' -f1)
    echo -e "${BLUE}Expected checksum: $expected_checksum${NC}"

    # Compare checksums
    if [ "$computed_checksum" != "$expected_checksum" ]; then
        echo -e "${RED}❌ Checksum verification failed${NC}"
        echo -e "${RED}Expected: $expected_checksum${NC}"
        echo -e "${RED}Got: $computed_checksum${NC}"
        echo -e "${BLUE}Continuing with installation anyway...${NC}"
    else
        echo -e "${GREEN}✅ Checksum verification successful!${NC}"
    fi
}

# Install the scripts
install_scripts() {
    echo -e "${BLUE}Installing scripts to $DESTINATION_DIR...${NC}"
    
    # Copy encrypt.py to bin directory
    cp "encrypt.py" "$DESTINATION_DIR/encrypt.py"
    
    # Create the cryptonit wrapper script
    cat > "$DESTINATION_PATH" << 'EOF'
#!/bin/bash
python3 "$HOME/bin/encrypt.py" "$@"
EOF
    
    # Make scripts executable
    chmod +x "$DESTINATION_PATH"
    chmod +x "$DESTINATION_DIR/encrypt.py"
    
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
    rm -f "$SCRIPT_NAME" "checksum.sha256" "encrypt.py"
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
}

# Run main installation
main
