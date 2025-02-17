# CRYPTONIT 🔓
## 🔒 AES-256-CBC Encryption/Decryption Script 🔓



This script provides a simple yet secure method to encrypt and decrypt files using the AES-256-CBC algorithm with password protection.

## 📋 Table of Contents

- [⭐ Features](#-features)
- [📦 Requirements](#-requirements)
- [Quick instal](#-quick-install)
- [⚙️ Installation](#installation)
- [📝 Usage](#-usage)
- [💡 Example](#-example)
- [🔒 Security Considerations](#-security-considerations)
- [🔍 How it Works](#-how-it-works)
- [📜 encrypt.py](#encryptpy)
- [⚠️ Disclaimer](#-disclaimer)

## ⭐ Features

- Secure AES-256-CBC encryption.
- User-provided password for encryption.
- Password protection with PBKDF2 key derivation.
- Automatic output filename generation with `"_crypt"` suffix for encrypted files.

## 📦 Requirements

- Bash shell
- OpenSSL library

## Quick install
use only one command for install 'cryptonit' bin file
```sh
curl -sSL https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git/master/install-not-bin.sh | bash
```
## ⚙️ Installation

To use this script, ensure you have OpenSSL installed on your system. If you don't have it installed, you can typically install it using your system's package manager. Here are some examples:

### Ubuntu/Debian

```sh
sudo apt update
sudo apt install openssl
```
### CentOS/RHEL

```sh
sudo yum install openssl
```
### macOS

```sh
brew install openssl
```
### Windows

For Windows, you can download OpenSSL binaries from the official OpenSSL website [here](https://www.openssl.org).

## 📝 Easy usage
just follow the workflow ;)
```sh
cryptonit
```
- `🔑 Enter password for AES-256-CBC encryption (or press Enter to use hardcoded): 
- Please enter the operation (encrypt/decrypt or e/d): 
- Please enter the input file name:

## 💡 Example

Encrypt a file:

```sh
use cryponit or ./encrypt.sh
```
- `🔑 Enter password for AES-256-CBC encryption (or press Enter to use hardcoded): pass is hiden
- Please enter the operation (encrypt/decrypt or e/d): e
- Please enter the input file name: my_secret_file.txt

This will encrypt the file `my_secret_file.txt` and create a new file named `my_secret_file.txt_crypt`.

## 📝 Alternative Usage 
add arguments after './encrypt.sh' or after 'python encrypt.py'
```sh
./encrypt.sh [encrypt|decrypt] <inputfile>
```
- `encrypt`: Encrypts the specified file.
- `decrypt`: Decrypts the specified file.
- `<inputfile>`: The path to the file you want to encrypt or decrypt.

## 💡 Example

Encrypt a file:

```sh
./encrypt.sh encrypt my_secret_file.txt
```
This will encrypt the file `my_secret_file.txt` and create a new file named `my_secret_file.txt_crypt`.

## 🔒 Security Considerations

- **Hardcoded Password**: This script includes a commented-out section for a hardcoded password. Do not use this option! Always prompt the user for a password at runtime.
- **Password Strength**: Choose a strong and unique password for encryption.
- **Script Permissions**: Ensure this script has appropriate permissions to be executed.

## 🔍 How it Works

1. The script prompts the user for a password for encryption.
2. It checks for at least two arguments (operation and input file).
3. Based on the operation (`encrypt`/`decrypt`):
   - **Encryption**:
     - Extracts filename without path.
     - Generates output filename with "_crypt" suffix.
     - Uses `openssl enc` with AES-256-CBC, salt, and PBKDF2 for password derivation.
   - **Decryption**:
     - Checks if the input filename ends with "_crypt".
     - Generates output filename by removing "_crypt" suffix.
     - Uses `openssl enc -d` to decrypt the file.
4. The script displays a success or failure message based on the operation result.
5. Finally, it clears the password variable from memory for security reasons.

## 📜 encrypt.py

The `encrypt.py` script offers the same functionality as the Bash script, enabling file encryption and decryption using the AES-256-CBC algorithm. It provides a Python-based alternative for users who prefer or require Python for their workflow.

### Usage

```sh
python encrypt.py [encrypt|decrypt] <inputfile>
```

- `encrypt`: Encrypts the specified file.
- `decrypt`: Decrypts the specified file.
- `<inputfile>`: The path to the file you want to encrypt or decrypt.

### Example

Encrypt a file:

```sh
python encrypt.py encrypt my_secret_file.txt
```

This will encrypt the file `my_secret_file.txt` and create a new file named `my_secret_file.txt_crypt`.

## ⚠️ Disclaimer

This script is for educational purposes only. While it offers basic encryption, ensure you understand the limitations and potential vulnerabilities before using it for sensitive data.
```
