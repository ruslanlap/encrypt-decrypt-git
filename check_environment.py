import subprocess
import sys
import os

def check_openssl():
    try:
        result = subprocess.run(['openssl', 'version'], 
                              capture_output=True, 
                              text=True,
                              shell=True)
        if result.returncode == 0:
            print("✅ OpenSSL is installed and accessible")
            print(f"Version: {result.stdout.strip()}")
            return True
        else:
            print("❌ OpenSSL is installed but returned an error")
            print(f"Error: {result.stderr.strip()}")
            return False
    except FileNotFoundError:
        print("❌ OpenSSL is not installed or not in PATH")
        return False

def check_python():
    print(f"✅ Python version: {sys.version}")
    return True

def main():
    print("Checking environment for CRYPTONIT...\n")
    
    python_ok = check_python()
    print()
    openssl_ok = check_openssl()
    
    if python_ok and openssl_ok:
        print("\n✅ Your environment is ready for CRYPTONIT!")
    else:
        print("\n❌ Some requirements are missing:")
        if not openssl_ok:
            print("Please install OpenSSL:")
            print("1. Download from: https://slproweb.com/products/Win32OpenSSL.html")
            print("2. Choose 'Win64 OpenSSL v3.x.x' (latest version)")
            print("3. Run the installer")
            print("4. Add OpenSSL bin directory to PATH")
            print("   - Usually: C:\\Program Files\\OpenSSL-Win64\\bin")

if __name__ == "__main__":
    main()
