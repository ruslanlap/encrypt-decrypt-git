import os
import sys
import subprocess
import urllib.request
import hashlib
import shutil

def create_bin_directory():
    bin_dir = os.path.join(os.path.expanduser("~"), "bin")
    if not os.path.exists(bin_dir):
        os.makedirs(bin_dir)
    return bin_dir

def download_file(url, filename):
    print(f"Downloading {filename}...")
    urllib.request.urlretrieve(url, filename)

def verify_checksum(file_path, checksum_path):
    print("Verifying checksum...")
    with open(checksum_path, 'r') as f:
        expected_checksum = f.read().split()[0]
    
    with open(file_path, 'rb') as f:
        data = f.read()
        actual_checksum = hashlib.sha256(data).hexdigest()
    
    return actual_checksum == expected_checksum

def main():
    # Create bin directory
    bin_dir = create_bin_directory()
    
    # Download encrypt.py
    encrypt_py_url = "https://raw.githubusercontent.com/ruslanlap/encrypt-decrypt-git-python/master/encrypt.py"
    encrypt_py_path = os.path.join(bin_dir, "encrypt.py")
    download_file(encrypt_py_url, encrypt_py_path)
    
    # Create batch file wrapper
    batch_path = os.path.join(bin_dir, "cryptonit.bat")
    with open(batch_path, 'w') as f:
        f.write('@echo off\n')
        f.write(f'python "{encrypt_py_path}" %*\n')
    
    # Add bin directory to PATH if not already present
    user_path = os.environ.get('PATH', '').split(os.pathsep)
    if bin_dir not in user_path:
        subprocess.run(['setx', 'PATH', f"{os.environ['PATH']}{os.pathsep}{bin_dir}"], check=True)
        print(f"\nAdded {bin_dir} to PATH")
    
    print("\nInstallation completed successfully!")
    print("Please restart your terminal to use the 'cryptonit' command")
    print("\nUsage:")
    print("1. Open terminal and type: cryptonit")
    print("2. Follow the prompts to encrypt or decrypt files")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Error during installation: {e}")
        sys.exit(1)
