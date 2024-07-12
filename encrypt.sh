#!/bin/bash




echo "Enter password for AES-256-CBC encryption:"
read -s password

#or HARCODE password
# Hardcoded password for AES-256-CBC encryption
#password=""

# Check if at least two arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 [encrypt|decrypt] <inputfile>"
    exit 1
fi

# Get the operation (encrypt or decrypt) and the input file
operation="$1"
inputfile="$2"

# Check if the input file exists
if [ ! -f "$inputfile" ]; then
    echo "Input file '$inputfile' does not exist."
    exit 1
fi

# Perform the encryption or decryption based on the operation
if [ "$operation" == "encrypt" ]; then
    # Extract the filename without the path
    filename=$(basename -- "$inputfile")

    # Derive the output file name by adding "_crypt" to the base name
    outputfile="${filename}_crypt"

    # Encrypt the file using OpenSSL with PBKDF2
    openssl enc -aes-256-cbc -salt -pbkdf2 -in "$inputfile" -out "$outputfile" -pass pass:"$password"

    if [ $? -eq 0 ]; then
        echo "Encryption complete. Output file: $outputfile"
    else
        echo "Encryption failed."
    fi

elif [ "$operation" == "decrypt" ]; then
    # Check if the input file ends with "_crypt"
    if ! [[ "$inputfile" =~ _crypt$ ]]; then
        echo "Decryption failed. Input file does not end with '_crypt'."
        exit 1
    fi

    # Derive the output file name by removing "_crypt" from the base name
    outputfile="${inputfile%_crypt}"

    # Decrypt the file using OpenSSL with PBKDF2
    openssl enc -d -aes-256-cbc -salt -pbkdf2 -in "$inputfile" -out "$outputfile" -pass pass:"$password"

    if [ $? -eq 0 ]; then
        echo "Decryption complete. Output file: $outputfile"
    else
        echo "Decryption failed."
    fi

else
    echo "Usage: $0 [encrypt|decrypt] <inputfile>"
    exit 1
fi

# Clear the password variable for security
unset password
