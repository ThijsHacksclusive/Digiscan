#!/bin/bash

input_file="filtered_output.csv"
output_file="testssl_results_csvverzameling/Referrer_policy_results.csv"

echo "Referrer Policy,ip,result" > "$output_file"

# Filter and process Referrer-Policy rows
grep '"Referrer-Policy"' "$input_file" | while IFS=',' read -r id fqdn_ip finding cve cwe; do
  clean_finding=$(echo "$finding" | tr -d '"')
  ip=$(echo "$fqdn_ip"| tr -d '"')

  if [[ "$clean_finding" == same-origin* ]]; then
    result="Goed"
  elif [[ "$clean_finding" == no-referrer* ]]; then
    result="Goed"
  else
    result="Onvoldoende"
  fi

  echo "Referrer Policy is $clean_finding,$ip,$result" >> "$output_file"
done

# Show result
cat "$output_file"
