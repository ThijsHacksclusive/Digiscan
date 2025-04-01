#!/bin/bash

set -e

echo "🔧 Setting up your scanner project..."

# Ensure base tools are installed
sudo apt update
sudo apt install -y curl git ffuf

# Clone testssl.sh if it doesn't exist
if [ ! -d "testssl.sh" ]; then
  echo "⬇️ Cloning testssl.sh..."
  git clone --depth 1 https://github.com/drwetter/testssl.sh.git testssl.sh
fi

# Make scripts executable
chmod +x scanner_met_menu.sh test.sh
chmod +x scans/*.sh

echo "✅ Setup complete. Run with: ./scanner_met_menu.sh"
