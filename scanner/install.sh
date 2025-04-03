#!/bin/bash
set -e

echo "🔧 Starting setup..."

# Step 1: Detect OS
detect_os() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
  elif [ "$(uname)" == "Darwin" ]; then
    OS="macos"
  else
    OS="unknown"
  fi
  echo "🧠 Detected OS: $OS"
  echo "$OS" > .os_type
}

detect_os

# Step 2: Use OS to install packages
case "$OS" in
  ubuntu|debian)
    echo "📦 Installing dependencies with apt..."
    #sudo apt update
    #sudo apt install -y curl git ffuf
    ;;
  fedora|centos|rhel)
    echo "📦 Installing dependencies with dnf/yum..."
    #sudo dnf install -y curl git ffuf || sudo yum install -y curl git ffuf
    ;;
  arch)
    echo "📦 Installing dependencies with pacman..."
    #sudo pacman -Sy --noconfirm curl git ffuf
    ;;
  macos)
    echo "📦 Installing dependencies with Homebrew..."
    #brew install curl git ffuf
    ;;
  *)
    echo "❌ Unsupported OS: $OS"
    exit 1
    ;;
esac

# Step 3: Clone testssl.sh if missing
if [ ! -d "testssl.sh" ]; then
  echo "⬇️ Cloning testssl.sh..."
  #git clone --depth 1 https://github.com/drwetter/testssl.sh.git testssl.sh
fi

# Step 4: Make scripts executable
chmod +x scanner_met_menu.sh test.sh
chmod +x scans/*.sh

echo "✅ Setup complete. Use ./scanner_met_menu.sh to start."
