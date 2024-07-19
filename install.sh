#!/bin/bash

# Define variables
BINARY_NAME="cryptonit"
BINARY_URL="https://github.com/ruslanlap/encrypt-decrypt-git/releases/download/v1.0.1/cryptonit"
CHECKSUM_URL="https://github.com/ruslanlap/encrypt-decrypt-git/releases/download/v1.0.1/cryptonit.sha256"
DESTINATION_DIR="$HOME/bin"
DESTINATION_PATH="$DESTINATION_DIR/$BINARY_NAME"

# Create destination directory if it doesn't exist
mkdir -p "$DESTINATION_DIR"

# Function to download and verify the checksum
download_and_verify() {
  echo "Downloading '$BINARY_NAME' from GitHub..."
  curl -o "$BINARY_NAME" -L "$BINARY_URL"
  
  echo "Downloading checksum..."
  curl -o "checksum.sha256" -L "$CHECKSUM_URL"
  
  echo "Verifying checksum..."
  sha256sum -c checksum.sha256
  if [ $? -ne 0 ]; then
    echo "❌ Checksum verification failed."
    exit 1
  fi
}

# Download and verify the binary
download_and_verify

# Copy the binary to the destination directory
echo "Copying '$BINARY_NAME' to '$DESTINATION_PATH'..."
cp "$BINARY_NAME" "$DESTINATION_PATH"

# Make the binary executable
echo "Making '$DESTINATION_PATH' executable..."
chmod +x "$DESTINATION_PATH"

# Confirm completion
echo "✅ Installation complete! You can now use the '$BINARY_NAME' command."

# Clean up
rm "$BINARY_NAME" checksum.sha256

# Add ~/bin to the PATH if it's not already in the PATH
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
    echo "~/bin has been added to your PATH. Please restart your terminal or run 'source ~/.bashrc' or 'source ~/.zshrc'."
else
    echo "~/bin is already in your PATH."
fi

