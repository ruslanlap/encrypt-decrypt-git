#!/bin/bash

# Check if OpenSSL is installed
if ! command -v openssl &> /dev/null; then
    echo -e "\033[1;31mError: OpenSSL is not installed\033[0m"
    echo "Please install OpenSSL first:"
    echo "For Ubuntu/Debian: sudo apt-get install openssl"
    echo "For CentOS/RHEL: sudo yum install openssl"
    echo "For Fedora: sudo dnf install openssl"
    exit 1
fi

# Function to show usage
show_usage() {
    echo "Usage: $0 [encrypt|decrypt] <file>"
    echo "Or run without arguments for interactive mode"
    echo "Examples:"
    echo "  $0 encrypt secret.txt"
    echo "  $0 decrypt secret.txt_crypt"
    exit 1
}

# Function to get operation from user
get_operation() {
    while true; do
        read -p "Choose operation (encrypt/decrypt) [e/d]: " op
        case $op in
            [Ee]* ) echo "encrypt"; return;;
            [Dd]* ) echo "decrypt"; return;;
            * ) echo "Please answer encrypt(e) or decrypt(d)";;
        esac
    done
}

# Function to get input file from user
get_input_file() {
    local op=$1
    local file=""
    while true; do
        read -p "Enter path to file to $op: " input
        if [ -z "$input" ]; then
            echo "Error: Please enter a file path"
            continue
        fi
        
        # Expand the path (handle ~, etc.)
        file=$(eval echo "$input")
        
        if [ -f "$file" ]; then
            # For decryption, check if file ends with _crypt
            if [ "$op" = "decrypt" ] && [[ "$file" != *"_crypt" ]]; then
                echo "Error: Decryption input file must end with '_crypt'"
                continue
            fi
            echo "$file"
            break
        else
            echo "Error: File '$file' does not exist"
        fi
    done
}

# Interactive or command line mode
if [ $# -eq 0 ]; then
    # Interactive mode
    operation=$(get_operation)
    input_file=$(get_input_file "$operation")
elif [ $# -eq 2 ]; then
    # Command line mode
    operation=$1
    input_file=$2
    
    # Validate operation
    if [[ "$operation" != "encrypt" && "$operation" != "decrypt" ]]; then
        echo "Invalid operation. Use 'encrypt' or 'decrypt'"
        show_usage
    fi
    
    # Check if input file exists
    if [ ! -f "$input_file" ]; then
        echo "Error: Input file '$input_file' does not exist"
        exit 1
    fi
    
    # For decryption, check if file ends with _crypt
    if [ "$operation" = "decrypt" ] && [[ "$input_file" != *"_crypt" ]]; then
        echo "Error: Decryption input file must end with '_crypt'"
        exit 1
    fi
else
    show_usage
fi

# Set output filename
if [ "$operation" = "encrypt" ]; then
    output_file="${input_file}_crypt"
else
    output_file="${input_file%_crypt}"
fi

# Get password
read -s -p "Enter password for $operation: " password
echo

# Perform operation
if [ "$operation" = "encrypt" ]; then
    openssl enc -aes-256-cbc -salt -pbkdf2 -in "$input_file" -out "$output_file" -pass "pass:$password"
    if [ $? -eq 0 ]; then
        echo "File encrypted successfully: $output_file"
    else
        echo "Encryption failed"
        exit 1
    fi
else
    openssl enc -d -aes-256-cbc -salt -pbkdf2 -in "$input_file" -out "$output_file" -pass "pass:$password"
    if [ $? -eq 0 ]; then
        echo "File decrypted successfully: $output_file"
    else
        echo "Decryption failed. Wrong password?"
        rm -f "$output_file"
        exit 1
    fi
fi
