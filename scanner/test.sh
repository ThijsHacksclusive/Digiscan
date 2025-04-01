#!/bin/bash

website_url=$1
scan_type=$2

# Read OS type from file (created by install.sh)
if [ -f .os_type ]; then
    OS=$(cat .os_type)
else
    OS="unknown"
fi

# Terminal launch command based on OS
launch_cmd() {
    local cmd="$1"

    case "$OS" in
        ubuntu|debian|fedora|centos|rhel|arch)
            # On Linux: launch in gnome-terminal (fallback to inline)
            if command -v gnome-terminal &> /dev/null; then
                gnome-terminal -- bash -c "$cmd; read -p 'Press enter to close...'"
            else
                echo "⚠️ gnome-terminal not found. Running inline:"
                bash -c "$cmd"
            fi
            ;;
        macos)
            # On macOS: use Terminal.app (or iTerm)
            osascript -e "tell application \"Terminal\" to do script \"$cmd; read -p 'Press enter to close...'\""
            ;;
        *)
            # Default to wt.exe (assume WSL or Windows)
            wt.exe --window last new-tab bash -ic "$cmd"
            ;;
    esac
}

# Dispatch based on scan type
case $scan_type in 
    1) 
        launch_cmd "cd scans && echo $website_url && bash ./testssl_scans.sh $website_url" &
        launch_cmd "cd scans && echo $website_url && bash ./HTTP_method_scanner.sh $website_url" &
        launch_cmd "cd scans && echo $website_url && bash ./portscan.sh $website_url"
        ;;
    2)
        launch_cmd "cd scans && echo $website_url && bash ./testssl_scans.sh $website_url && ./nog_een_test.sh $website_url && ./CSP_check.sh && ./curvestest.sh && ./ff_groupstest.sh && ./maxage.sh && ./OCSP_stapling_check.sh && ./Referrer_policy.sh && ./RSA_keysize_check.sh && ./Secure_renego.sh && ./X_Content_Type_Options.sh && ./alles_bij_elkaar.sh"
        ;;
    3)
        launch_cmd "cd scans && echo $website_url && bash ./HTTP_method_scanner.sh $website_url"
        ;;
    4)
        launch_cmd "cd scans && echo $website_url && bash ./portscan.sh $website_url"
        ;;
    5)
        launch_cmd "cd scans && echo $website_url && bash ./ffuf_scan.sh $website_url" &
        launch_cmd "cd scans && echo $website_url && bash ./webanalyse.sh $website_url"
        ;;
    6)
        launch_cmd "cd scans/testssl_eisen && bash ./csv_editor.sh"
        ;;
    *)
        echo "❌ Invalid scan type: $scan_type"
        ;;
esac
