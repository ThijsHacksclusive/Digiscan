#!/usr/bin/env bash

website_url="$1"
scan_type="$2"
OS="$3"  # Passed from main script

# Fallback if not passed
if [ -z "$OS" ]; then
    OS="unknown"
fi

launch_cmd() {
    local cmd="$1"

    case "$OS" in
        wsl)
            # Headless: run inline
            echo "▶ Running inline (no terminal GUI in $OS):"
            wt -w 0 cmd
            ;;
        macos)
            # macOS Terminal
            osascript -e "tell application \"Terminal\" to do script \"$cmd\""
            ;;
        *)
            # Default fallback (Windows Terminal if available)
            if command -v wt.exe &> /dev/null; then
                wt.exe --window last new-tab bash -ic "$cmd"
            else
                echo "⚠️ No GUI terminal found. Running inline:"
                bash -c "$cmd"
            fi
            ;;
    esac
}


# Dispatch based on scan type
case "$scan_type" in 
    1) 
        launch_cmd "cd scans && echo $website_url && bash ./testssl_scans.sh $website_url" &
        launch_cmd "cd scans && echo $website_url && bash ./HTTP_method_scanner.sh $website_url" &
        launch_cmd "cd scans && echo $website_url && bash ./portscan.sh $website_url"
        ;;
    2)
        launch_cmd "cd Digiscan && cd scanner && cd scans && echo $website_url && bash ./testssl_scans.sh $website_url && ./nog_een_test.sh $website_url && ./CSP_check.sh && ./curvestest.sh && ./ff_groupstest.sh && ./maxage.sh && ./OCSP_stapling_check.sh && ./Referrer_policy.sh && ./RSA_keysize_check.sh && ./Secure_renego.sh && ./X_Content_Type_Options.sh && ./alles_bij_elkaar.sh && echo "Enter name" && read name && echo $name"
        ;;
    3)
        launch_cmd "cd scans && echo $website_url && bash ./HTTP_method_scanner.sh $website_url"
        ;;
    4)
        launch_cmd "cd scans && echo $website_url && bash ./portscan.sh $website_url "
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
