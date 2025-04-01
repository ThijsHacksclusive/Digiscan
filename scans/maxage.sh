#!/bin/bash

input_file="filtered_output.csv"
output_file="testssl_results_csvverzameling/cache_control_result.csv"

classify_age() {
    local age=$1
    if [[ -z $age ]]; then
        echo "N/A"
    elif (( age > 31536000 )); then
        echo "Goed"
    else
        echo "Onvoldoende"
    fi
}

echo "s-maxage: Value,ip,Result" > "$output_file"

while IFS= read -r line; do
    if [[ $line == \"Cache-Control\"* ]]; then
        fqdn_ip=$(echo "$line" | cut -d',' -f2 | tr -d '"')
        cache_control=$(echo "$line" | cut -d',' -f3 | tr -d '"')

        ip="${fqdn_ip}"

        s_max_age=$(echo "$cache_control" | grep -oP 's-maxage=\K[0-9]+')

        echo "s-maxage: $s_max_age,$ip,$(classify_age "$s_max_age")" >> "$output_file"
        break
    fi
done < "$input_file"


  