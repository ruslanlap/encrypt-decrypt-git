import os
import sys
import subprocess
import getpass
import time

def get_username():
    result = subprocess.run(['whoami'], capture_output=True, text=True)
    return result.stdout.strip()

username = get_username()
print(f"Hello {username}, how are you?")

def banner():
    print("\n🔐 \033[1;35mEncryption/Decryption Wizard 🔓\033[0m")
    print("\033[1;36m====================================\033[0m\n")

def prompt_password():
    password = getpass.getpass("🔑 \033[1;34mEnter password for AES-256-CBC encryption (or press Enter to use hardcoded):\033[0m ")
    return password if password else "your_hardcoded_password"  # Replace with your hardcoded password

def prompt_for_operation():
    operation = input("🔄 \033[1;34mPlease enter the operation (encrypt/decrypt or e/d):\033[0m ").strip().lower()
    while operation not in ["encrypt", "decrypt", "e", "d"]:
        print("\n❌ \033[1;31mInvalid operation. Please enter 'encrypt', 'decrypt', 'e', or 'd'.\033[0m")
        operation = input("🔄 \033[1;34mPlease enter the operation (encrypt/decrypt or e/d):\033[0m ").strip().lower()
    return operation

def prompt_for_file():
    inputfile = input("📄 \033[1;34mPlease enter the input file name:\033[0m ").strip()
    while not os.path.isfile(inputfile):
        print("\n❌ \033[1;31mInput file '{}' does not exist.\033[0m".format(inputfile))
        inputfile = input("📄 \033[1;34mPlease enter the input file name:\033[0m ").strip()
    return inputfile

def loading_animation(process):
    spin = '-\\|/'
    i = 0
    while process.poll() is None:
        i = (i + 1) % 4
        sys.stdout.write("\r" + spin[i])
        sys.stdout.flush()
        time.sleep(0.1)
    print("")

def encrypt_file(inputfile, password):
    filename = os.path.basename(inputfile)
    outputfile = "{}_crypt".format(filename)

    print("\n🔒 \033[1;33mEncrypting file...\033[0m")
    process = subprocess.Popen(
        ["openssl", "enc", "-aes-256-cbc", "-salt", "-pbkdf2", "-in", inputfile, "-out", outputfile, "-pass", "pass:{}".format(password)],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    loading_animation(process)

    stdout, stderr = process.communicate()
    if process.returncode == 0:
        print("\n✅ \033[1;32mEncryption complete! 🎉\033[0m")
        print("📁 \033[1;32mOutput file: {}\033[0m".format(outputfile))
    else:
        print("\n❌ \033[1;31mEncryption failed. 😞\033[0m\n{}".format(stderr.decode()))

def decrypt_file(inputfile, password):
    if not inputfile.endswith("_crypt"):
        print("\n❌ \033[1;31mDecryption failed. Input file does not end with '_crypt'. 😕\033[0m")
        sys.exit(1)

    outputfile = inputfile[:-6]

    print("\n🔓 \033[1;33mDecrypting file...\033[0m")
    process = subprocess.Popen(
        ["openssl", "enc", "-d", "-aes-256-cbc", "-salt", "-pbkdf2", "-in", inputfile, "-out", outputfile, "-pass", "pass:{}".format(password)],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    loading_animation(process)

    stdout, stderr = process.communicate()
    if process.returncode == 0:
        print("\n✅ \033[1;32mDecryption complete! 🎉\033[0m")
        print("📁 \033[1;32mOutput file: {}\033[0m".format(outputfile))
    else:
        print("\n❌ \033[1;31mDecryption failed. 😞\033[0m\n{}".format(stderr.decode()))

if __name__ == "__main__":
    banner()
    password = prompt_password()

    if len(sys.argv) < 2:
        operation = prompt_for_operation()
    else:
        operation = sys.argv[1]

    if operation in ["e", "encrypt"]:
        operation = "encrypt"
    elif operation in ["d", "decrypt"]:
        operation = "decrypt"

    if len(sys.argv) < 3:
        inputfile = prompt_for_file()
    else:
        inputfile = sys.argv[2]

    if operation == "encrypt":
        encrypt_file(inputfile, password)
    elif operation == "decrypt":
        decrypt_file(inputfile, password)
    else:
        print("\n❌ \033[1;31mUsage: {} [encrypt|decrypt] <inputfile>\033[0m".format(sys.argv[0]))
        sys.exit(1)

    print("\n\033[1;36m====================================\033[0m")
    print("\033[1;35m🎭 Operation completed! 🎭\033[0m\n")
