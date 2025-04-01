#!/bin/bash

input_file="filtered_output.csv"
check_file="testssl_eisen/Finite_field_groepen.csv"
output_file="testssl_results_csvverzameling/dh_results.csv"

echo "group,ip,result" > "$output_file"

# Function to get result for a DH group
get_result() {
  local group="$1"
  while IFS=';' read -r name voldoende uit_te_faseren onvoldoende; do
    if [[ "$name" == "$group" ]]; then
      if [[ "$voldoende" == "X" ]]; then echo "Voldoende"
      elif [[ "$uit_te_faseren" == "X" ]]; then echo "Uit te faseren"
      elif [[ "$onvoldoende" == "X" ]]; then echo "Onvoldoende"
      else echo "Onvoldoende"
      fi
      return
    fi
  done < <(tail -n +2 "$check_file")
  echo "Onvoldoende"
}

# Check if DH_groups row exists
dh_row=$(grep '"DH_groups"' "$input_file")

if [[ -z "$dh_row" ]]; then
  echo "No finite field groups found,N.V.T,Goed" >> "$output_file"
else
  # Process the DH_groups row
  IFS=',' read -r id fqdn_ip finding cve cwe <<< "$dh_row"
  ip="${fqdn_ip//\"/}"   
  dh_groups=$(echo "$finding" | tr -d '"' | tr ' ' '\n')

  while IFS= read -r group; do
    [[ -z "$group" ]] && continue
    result=$(get_result "$group")
    echo "$group,$ip,$result" >> "$output_file"
  done <<< "$dh_groups"
fi

# Show result
cat "$output_file"
