#!/bin/bash

# Function to process website URL
process_website() {
    website_url=$1

    echo "Website URL: $website_url"    

    # Process selected options
    for choice in "${choices_array[@]}"; do
        case $choice in
            1) echo "- Option 1 (Executing external script...)"
               bash ./test.sh "$website_url" 1
               ;;
            2) echo "- Option 2  (Executing external script...)"
               bash ./test.sh "$website_url" 2
               ;;
            3) echo "- Option 3 (Executing external script...)"
               bash ./test.sh "$website_url" 3
               ;;
            4) echo "- Option 4 (Executing external script...)"
               bash ./test.sh "$website_url" 4
               ;;
            5) echo "- Option 5 (Executing external script...)"
               bash ./test.sh "$website_url" 5
               ;; 
            *) echo "Invalid choice: $choice"
               ;;
        esac
    done
}

# --- Main Program ---

# Display selection menu (this will be applied to all sites)
echo "Select options (separate multiple choices with spaces):"
echo "1) HTTP Methods (Runs external script)"
echo "2) testssl"
echo "3) Port scan"
echo "4) Option 4"
echo "5) Option 5 ffuf"
echo "6) Edit Audit Settings (does NOT require a website)"
read -p "Enter your choices: " choices

# Convert input into an array
choices_array=($choices)

# If option 6 is selected, run it immediately (no website input needed)
for choice in "${choices_array[@]}"; do
    if [[ "$choice" == "6" ]]; then
        echo "- Option 6 (Executing external script...)"
        bash ./test.sh "https://dummy.url" 6
        # Remove option 6 from the array so it doesn't get processed again
        choices_array=("${choices_array[@]/6}")
        break
    fi
done

# If any other options are selected, prompt for URLs
if [[ ${#choices_array[@]} -gt 0 ]]; then
    # List of URLs to process
    url_list=()

    echo "Enter website URLs (any format), one per line. Type 'done' when finished."
    while true; do
        read -p "Enter a website URL: " website_url
        if [[ "$website_url" == "done" ]]; then
            break
        fi

        url_list+=("$website_url")
    done

    # Process each URL in the list
    for website_url in "${url_list[@]}"; do
        process_website "$website_url"
    done
fi
