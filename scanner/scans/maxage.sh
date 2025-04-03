#!/usr/bin/env bash

input_file="filtered_output.csv"
output_file="testssl_results_csvverzameling/cache_control_result.csv"

OS="${2:-unknown}"  # Optional OS argument from parent script
echo "Running Cache-Control s-maxage check on OS: $OS"
echo "Input file: $input_file"
echo "Output file: $output_file"

# Function to classify max age
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

# CSV header
echo "s-maxage: Value,ip,Result" > "$output_file"

# Process lines
while IFS= read -r line; do
    if [[ "$line" == \"Cache-Control\"* ]]; then
        fqdn_ip=$(echo "$line" | cut -d',' -f2 | tr -d '"')
        cache_control=$(echo "$line" | cut -d',' -f3 | tr -d '"')

        ip="$fqdn_ip"
        s_max_age=$(echo "$cache_control" | grep -oP 's-maxage=\K[0-9]+')

        echo "s-maxage: $s_max_age,$ip,$(classify_age "$s_max_age")" >> "$output_file"
        break
    fi
done < "$input_file"
