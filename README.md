# AES-256-CBC Encryption/Decryption Script

This script provides a simple yet secure method to encrypt and decrypt files using the AES-256-CBC algorithm with password protection.

## Features

- Secure AES-256-CBC encryption.
- User-provided password for encryption.
- Password protection with PBKDF2 key derivation.
- Automatic output filename generation with "_crypt" suffix for encrypted files.

## Requirements

- Bash shell
- OpenSSL library

## Usage

```bash
./script.sh [encrypt|decrypt] <inputfile>
```

- `encrypt`: Encrypts the specified file.
- `decrypt`: Decrypts the specified file.
- `<inputfile>`: The path to the file you want to encrypt or decrypt.

## Example

Encrypt a file:

```bash
./script.sh encrypt my_secret_file.txt
```

This will encrypt the file `my_secret_file.txt` and create a new file named `my_secret_file.txt_crypt`.

## Security Considerations

- **Hardcoded Password**: This script includes a commented-out section for a hardcoded password. Do not use this option! Always prompt the user for a password at runtime.
- **Password Strength**: Choose a strong and unique password for encryption.
- **Script Permissions**: Ensure this script has appropriate permissions to be executed.

## How it Works

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

## Disclaimer

This script is for educational purposes only. While it offers basic encryption, ensure you understand the limitations and potential vulnerabilities before using it for sensitive data.
```

