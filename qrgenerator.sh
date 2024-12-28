#!/bin/bash

# Function to check if libqrencode is installed
check_libqrencode_installed() {
  command -v qrencode &> /dev/null
}

# Function to install libqrencode if not installed
install_libqrencode() {
  echo "libqrencode is not installed. Would you like to install it now?"
  read -p "Enter Y to install or N to exit: " answer
  check_exit "$answer"
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    pkg install libqrencode -y
    if [ $? -eq 0 ]; then
      echo "libqrencode successfully installed."
    else
      echo "Installation failed. Please check your Termux setup."
      exit 1
    fi
  else
    echo "You need to install libqrencode to proceed. Exiting."
    exit 1
  fi
}

# Function to check if the user wants to quit
check_exit() {
  case "$1" in
    [Qq])
      echo "Exiting..."
      exit 0
      ;;
  esac
}

# Check if libqrencode is installed, otherwise prompt to install
if ! check_libqrencode_installed; then
  install_libqrencode
fi

# Main Program
while true; do
  echo "Enter the web address (URL) to generate a QR code for (type 'q' to quit):"
  read url
  check_exit "$url"

  echo "Enter the filename (without extension) to save the QR code image (type 'q' to quit):"
  read filename
  check_exit "$filename"

  # Generate QR code and save it as a PNG file
  qrencode -o "$filename.png" "$url"

  # Notify user of successful QR code generation
  echo "QR Code saved as $filename.png"

  echo "Would you like to generate another QR code? (type 'q' to quit, or any other key to continue.)"
  read continue_response
  check_exit "$continue_response"
done
