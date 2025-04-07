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

# Step 2: Install or check dependencies
check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo "❌ $1 is not installed."
    MISSING_TOOLS+=("$1")
  fi
}

MISSING_TOOLS=()

case "$OS" in
  ubuntu|debian)
    echo "📦 Installing dependencies with apt..."
    sudo apt update
    sudo apt install -y curl git ffuf
    ;;
  fedora|centos|rhel)
    echo "📦 Installing dependencies with dnf/yum..."
    sudo dnf install -y curl git ffuf || sudo yum install -y curl git ffuf
    ;;
  arch)
    echo "📦 Installing dependencies with pacman..."
    sudo pacman -Sy --noconfirm curl git ffuf
    ;;
  macos)
    echo "🔎 Checking for required tools..."
    check_command curl
    check_command git
    check_command ffuf

    if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
      echo ""
      echo "⚠️ The following tools are missing: ${MISSING_TOOLS[*]}"
      echo "👉 Please install them manually before continuing."
      echo "   You can use MacPorts, source installs, or download binaries from the official sites:"
      echo "   - curl:    https://curl.se"
      echo "   - git:     https://git-scm.com"
      echo "   - ffuf:    https://github.com/ffuf/ffuf/releases"
      exit 1
    fi
    ;;
  *)
    echo "❌ Unsupported OS: $OS"
    exit 1
    ;;
esac

# Step 3: Clone testssl.sh if missing
if [ ! -d "testssl.sh" ]; then
  echo "⬇️ Cloning testssl.sh..."
  git clone --depth 1 https://github.com/drwetter/testssl.sh.git testssl.sh
fi

# Step 4: Make scripts executable
chmod +x scanner_met_menu.sh test.sh
chmod +x scans/*.sh

echo "✅ Setup complete. Use ./scanner_met_menu.sh to start."
