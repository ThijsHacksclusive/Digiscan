#!/bin/bash

input_file="filtered_output.csv"
output_file="testssl_results_csvverzameling/x_content_type_options_results.csv"

echo "X-Content-Type-Options,ip,result" > "$output_file"

grep '"X-Content-Type-Options"' "$input_file" | while IFS=',' read -r id fqdn_ip finding cve cwe; do
  clean_finding=$(echo "$finding" | tr -d '"')
  ip=$(echo "$fqdn_ip"| tr -d '"')

  if [[ "$clean_finding" == "nosniff" ]]; then
    result="Goed"
  else
    result="Onvoldoende"
  fi

  echo "X-Content-Type-Options found: $clean_finding,$ip,$result" >> "$output_file"
done

if ! grep -q '"X-Content-Type-Options"' "$input_file"; then
  echo "No X-Content-Type-Options found,$ip,Onvoldoende" >> "$output_file"
fi

cat "$output_file"
