#!/bin/bash

input_file="filtered_output.csv"
output_file="testssl_results_csvverzameling/ocsp_stapling_results.csv"

echo "OCSP stapling,ip,result" > "$output_file"

# Filter and process OCSP_stapling rows
grep '^"OCSP_stapling' "$input_file" | while IFS=',' read -r id fqdn_ip finding cve cwe; do
  clean_finding=$(echo "$finding" | tr -d '"')
  ip=$(echo "$fqdn_ip"| tr -d '"')

  if [[ "$clean_finding" == "offered" ]]; then
    result="Goed"
  elif [[ "$clean_finding" == "not offered" ]]; then
    result="Voldoende"
  else
    result="Onvoldoende"
  fi

  echo "OCSP stapling is $clean_finding,$ip,$result" >> "$output_file"
done

# Show result
cat "$output_file"
