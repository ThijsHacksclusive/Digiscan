#!/bin/bash

detect_os() {
  uname_out="$(uname -s)"

  case "${uname_out}" in
      Linux*)     os="Linux";;
      Darwin*)    os="macOS";;
      CYGWIN*|MINGW*|MSYS*) os="Windows";;
      *)          os="Unknown"
  esac

  echo "Detected OS: $os"
}

detect_os
