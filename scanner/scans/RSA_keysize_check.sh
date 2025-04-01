#!/bin/bash

input_file="filtered_output.csv"
output_file="testssl_results_csvverzameling/cert_keysize_results.csv"

echo "RSA,ip,result" > "$output_file"

grep '^"cert_keySize' "$input_file" | while IFS=',' read -r id fqdn_ip finding cve cwe; do
  bit_size=$(echo "$finding" | grep -oE 'RSA [0-9]+' | awk '{print $2}')
  ip=$(echo "$fqdn_ip"| tr -d '"')

  # Default if nothing found
  [[ -z "$bit_size" ]] && continue

  # Determine result
  if (( bit_size >= 3072 )); then
    result="Goed"
  elif (( bit_size >= 2048 )); then
    result="Voldoende"
  else
    result="Onvoldoende"
  fi

  echo "RSA Keysize: $bit_size,$ip,$result" >> "$output_file"
done

# Show result
cat "$output_file"
