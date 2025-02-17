#!/bin/bash

# Define variables
BINARY_NAME="encrypt.sh"
BINARY_URL="https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git-python/master/encrypt.sh"
CHECKSUM_URL="https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git-python/master/encrypt.sh.sha256"
DESTINATION_DIR="$HOME/bin"
DESTINATION_PATH="$DESTINATION_DIR/cryptonit"

# Color codes for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create destination directory if it doesn't exist
mkdir -p "$DESTINATION_DIR"

# Function to download and verify the checksum with progress animation
download_and_verify() {
  echo -e "${BLUE}Downloading '$BINARY_NAME' from GitHub...${NC}"
  curl -o "$BINARY_NAME" -L "$BINARY_URL" &
  pid=$!
  spin='-\|/'
  i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(((i + 1) % 4))
    printf "\r${spin:$i:1}"
    sleep .1
  done
  echo -e "\r${GREEN}Download complete!${NC}"

  echo -e "${BLUE}Downloading checksum...${NC}"
  curl -o "checksum.sha256" -L "$CHECKSUM_URL"

  echo -e "${BLUE}Verifying checksum...${NC}"
  if ! sha256sum -c checksum.sha256; then
    echo -e "${RED}❌ Checksum verification failed.${NC}"
    exit 1
  fi
  echo -e "${GREEN}✅ Checksum verification successful!${NC}"
}

# Download and verify the binary
download_and_verify

# Copy the binary to the destination directory
echo -e "${BLUE}Copying '$BINARY_NAME' to '$DESTINATION_PATH'...${NC}"
cp "$BINARY_NAME" "$DESTINATION_PATH"

# Make the binary executable
echo -e "${BLUE}Making '$DESTINATION_PATH' executable...${NC}"
chmod +x "$DESTINATION_PATH"

# Confirm completion
echo -e "${GREEN}✅ Installation complete! You can now use the **cryptonit** command.${NC}"

# Clean up
rm "$BINARY_NAME" checksum.sha256

# Add ~/bin to the PATH if it's not already in the PATH
if echo "$PATH" | grep -q "$HOME/bin"; then
  echo -e "${BLUE}~/bin is already in your PATH.${NC}"
else
  echo 'export PATH="$HOME/bin:$PATH"' >>~/.bashrc
  echo 'export PATH="$HOME/bin:$PATH"' >>~/.zshrc
  if [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
  elif [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
  fi
  echo -e "${GREEN}✅ '~/bin' added to your PATH. You can now use the 'cryptonit' command.${NC}"
fi

read answer
if [[ $answer == [Yy]* ]]; then
  echo -e "${GREEN}Tip: Use 'cryptonit -h' to see available options and how to encrypt or decrypt files!${NC}"
else
  echo -e "${BLUE}Maybe next time!${NC}"
fi
