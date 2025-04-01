website_url=$1
scan_type=$2
case $scan_type in 
    1) 
        wt.exe --window last new-tab bash -ic "cd scans && echo $website_url && bash ./testssl_scans.sh $website_url" &
        wt.exe --window last new-tab bash -ic "cd scans && echo $website_url && bash ./HTTP_method_scanner.sh $website_url && read -p 'press enter to quit'" &
        wt.exe --window last new-tab bash -ic "cd scans && echo $website_url && bash ./portscan.sh $website_url"
        ;;
    2)
        wt.exe --window last new-tab bash -ic "cd scans && echo $website_url && bash ./testssl_scans.sh $website_url && ./nog_een_test.sh $website_url && ./CSP_check.sh && ./curvestest.sh && ./ff_groupstest.sh  && ./maxage.sh && ./OCSP_stapling_check.sh  && ./Referrer_policy.sh && ./RSA_keysize_check.sh && ./Secure_renego.sh && ./X_Content_Type_Options.sh && ./alles_bij_elkaar.sh && read -p 'press enter to quit'"
        ;;
    3)
        wt.exe --window last new-tab bash -ic "cd scans && echo $website_url && bash ./HTTP_method_scanner.sh $website_url && read -p 'press enter to quit'"
        ;;
    4)
        wt.exe --window last new-tab bash -ic "cd scans && echo $website_url && bash ./portscan.sh $website_url && read -p 'press enter to quit'"
        ;;
    5)
        wt.exe --window last new-tab bash -ic "cd cans && echo $website_url && bash ./ffuf_scan.sh $website_url && read -p 'press enter to quit'" &
        wt.exe --window last new-tab bash -ic "cd scans && echo $website_url && bash ./webanalyse.sh $website_url && read -p 'press enter to quit'"
        ;;
    6)
        wt.exe --window last new-tab bash -ic "cd scans/testssl_eisen && bash ./csv_editor.sh && read -p 'press enter to quit'"
        ;;
    *)
        echo "Invalid scan type: $scan_type"
        ;;
esac
