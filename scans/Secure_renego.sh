#!/bin/bash

input_file="filtered_output.csv"
output_file_serego="testssl_results_csvverzameling/Secure_renego_results.csv"
output_file_seclrego="testssl_results_csvverzameling/Secure_client_renego_results.csv"


echo "Secure Renegotiation,ip,result" > "$output_file_serego"

# Filter and process Referrer-Policy rows
grep '"secure_renego"' "$input_file" | while IFS=',' read -r id fqdn_ip finding cve cwe; do
  clean_finding=$(echo "$finding" | tr -d '"')
  ip=$(echo "$fqdn_ip"| tr -d '"')

  if [[ "$clean_finding" == supported* ]]; then
    result="Goed"
  else
    result="Onvoldoende"
  fi
  echo "Secure Renegotiation $clean_finding,$ip,$result" >> "$output_file_serego"
done

echo "Secure client Renegotiation,ip,result" > "$output_file_seclrego"

grep '"secure_client_renego"' "$input_file" | while IFS=',' read -r id fqdn_ip finding cve cwe; do
  clean_finding=$(echo "$finding" | tr -d '"')
  ip=$(echo "$fqdn_ip"| tr -d '"')

  if [[ "$clean_finding" == "not vulnerable" ]]; then
    result="Goed"
  else
    result="Onvoldoende"
  fi

  echo "Secure client Renegotiation $clean_finding,$ip,$result" >> "$output_file_seclrego"
done

# Show result
cat "$output_file_seclrego"
cat "$output_file_serego"

