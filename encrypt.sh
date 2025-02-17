#!/bin/bash
#!/bin/bash

usage() {
  echo "Використання: cryptonit [опції]"
  echo "Опції:"
  echo "  -h      Показати довідку"
  echo "  -e      Шифрувати файл (приклад)"
  echo "  -d      Розшифрувати файл (приклад)"
  # Додайте інші опції за потребою
}

if [[ $1 == "-h" ]]; then
  usage
  exit 0
fi

# Colorful banner
echo -e "\n\e[1;35m Encryption/Decryption Wizard \e[0m"
echo -e "\e[1;36m====================================\e[0m\n"
# Prompt for password or use hardcoded password
echo -e "\e[1;34m🔑 Enter password for AES-256-CBC encryption (or press Enter to use hardcoded):\e[0m"
read -s password
password=${password:-"your_hardcoded_password"} # Replace with your hardcoded password

# Check for arguments
if [ $# -eq 2 ]; then
  # Operation and input file provided as arguments
  operation="$1"
  inputfile="$2"
else
  # Prompt for operation (encrypt/decrypt or e/d)
  prompt_for_operation() {
    read -p $' \e[1;34mPlease enter the operation (encrypt/decrypt or e/d):\e[0m ' operation
    operation=$(echo "$operation" | tr '[:upper:]' '[:lower:]') # Convert to lowercase
    if [ "$operation" != "encrypt" ] && [ "$operation" != "decrypt" ] && [ "$operation" != "e" ] && [ "$operation" != "d" ]; then
      echo -e "\n❌ \e[1;31mInvalid operation. Please enter 'encrypt', 'decrypt', 'e', or 'd'.\e[0m"
      prompt_for_operation
    fi
  }
  prompt_for_operation

  # Prompt for input file
  prompt_for_file() {
    read -p $' \e[1;34mPlease enter the input file name:\e[0m ' inputfile
    if [ ! -f "$inputfile" ]; then
      echo -e "\n❌ \e[1;31mInput file '$inputfile' does not exist.\e[0m"
      prompt_for_file
    fi
  }
  prompt_for_file
fi
# Loading animation function
loading_animation() {
  pid=$!
  spin='-\|/'
  i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(((i + 1) % 4))
    printf "\r${spin:$i:1}"
    sleep .1
  done
  echo ""
}

# Perform the encryption or decryption based on the operation
if [ "$operation" == "encrypt" ] || [ "$operation" == "e" ]; then
  # Extract the filename without the path
  filename=$(basename -- "$inputfile")

  # Derive the output file name by adding "_crypt" to the base name
  outputfile="${filename}_crypt"

  echo -e "\n\e[1;33m🔒 Encrypting file...\e[0m"
  # Encrypt the file using OpenSSL with PBKDF2
  (openssl enc -aes-256-cbc -salt -pbkdf2 -in "$inputfile" -out "$outputfile" -pass pass:"$password") &
  loading_animation

  if [ $? -eq 0 ]; then
    echo -e "\n\e[1;32m✅ Encryption complete! 🎉\e[0m"
    echo -e "\e[1;32m📁 Output file: $outputfile\e[0m"
  else
    echo -e "\n\e[1;31m❌ Encryption failed. 😞\e[0m"
  fi

elif [ "$operation" == "decrypt" ] || [ "$operation" == "d" ]; then
  # Check if the input file ends with "_crypt"
  if ! [[ "$inputfile" =~ _crypt$ ]]; then
    echo -e "\n\e[1;31m❌ Decryption failed. Input file does not end with '_crypt'. 😕\e[0m"
    exit 1
  fi

  # Derive the output file name by removing "_crypt" from the base name
  outputfile="${inputfile%_crypt}"

  echo -e "\n\e[1;33m🔓 Decrypting file...\e[0m"
  # Decrypt the file using OpenSSL with PBKDF2
  (openssl enc -d -aes-256-cbc -salt -pbkdf2 -in "$inputfile" -out "$outputfile" -pass pass:"$password") &

  if [ $? -eq 0 ]; then
    echo -e "\n\e[1;32m✅ Decryption complete! 🎉\e[0m"
    echo -e "\e[1;32m📁 Output file: $outputfile\e[0m"
  else
    echo -e "\n\e[1;31m❌ Decryption failed. 😞\e[0m"
  fi

else
  echo -e "\n\e[1;31m❌ Usage: $0 [encrypt|decrypt] <inputfile>\e[0m"
  exit 1
fi

# Clear the password variable for security
unset password

echo -e "\n\e[1;36m====================================\e[0m"
echo -e "\e[1;35m🎭 Operation completed! 🎭\e[0m\n"

