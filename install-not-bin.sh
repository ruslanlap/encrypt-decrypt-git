#!/bin/bash

# Define variables
BINARY_NAME="encrypt.sh"
BINARY_URL="https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git/master/encrypt.sh"
CHECKSUM_URL="https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git/master/encrypt.sh.sha256"
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

  echo "Checksum file content:"
  cat checksum.sha256
#!/bin/bash

# Define variables
BINARY_NAME="encrypt.sh"
BINARY_URL="https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git/master/encrypt.sh"
CHECKSUM_URL="https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git/master/encrypt.sh.sha256"
DESTINATION_DIR="$HOME/bin/cryptonit"
DESTINATION_PATH="$DESTINATION_DIR/$BINARY_NAME"

# Create destination directory if it doesn't exist
mkdir -p "$DESTINATION_DIR"
# Function to download and verify the checksum
download_and_verify() {
  echo "Downloading '$BINARY_NAME' from GitHub..."
  curl -o "$BINARY_NAME" -L "$BINARY_URL"
  echo "Downloading checksum..."
  curl -o "checksum.sha256" -L "$CHECKSUM_URL"

  echo "Checksum file content:"
  cat checksum.sha256

  echo "Binary file checksum:"
  sha256sum "$BINARY_NAME"

  echo "Verifying checksum..."
  if ! sha256sum -c checksum.sha256; then
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

# Clean up
rm "$BINARY_NAME" checksum.sha256
# Add ~/bin to the PATH if it's not already in the PATH
#if echo "$PATH" | grep -q "$HOME/bin"; then
    #echo "~/bin is already in your PATH."
#else
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
    if [ -n "$BASH_VERSION" ]; then
        source ~/.bashrc
    elif [ -n "$ZSH_VERSION" ]; then
        source ~/.zshrc
    fi
    echo "✅ Installation complete! You can now use the 'cryptonit' command."
#fi

