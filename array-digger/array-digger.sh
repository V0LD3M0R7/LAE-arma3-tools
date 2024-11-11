#!/bin/bash

# Input HTML file
input_file="your_html_modpack.html"
output_file="mod_names_and_ids.txt"

# Function to lowercase mod names
convert_to_lowercase() {
    # Convert the string to lowercase
    echo "$1" | tr 'A-Z' 'a-z'
}

# Extract mod names and IDs and save to output file
grep -oP '(?<=<td data-type="DisplayName">).*?(?=</td>)' "$input_file" | while read -r mod_name; do
    # Clean the mod name: remove special characters, replace spaces with underscores, and lowercase it
    clean_mod_name=$(echo "$mod_name" | sed 's/[^a-zA-Z0-9 ]//g' | sed 's/ /_/g')
    clean_mod_name=$(convert_to_lowercase "$clean_mod_name")

    # Extract the mod ID from the corresponding <a href> link
    mod_id=$(grep -oP "(?<=<td data-type=\"DisplayName\">$mod_name</td>.*?id=)\d+" "$input_file")
    
    # Write clean, lowercased mod name and mod ID to the output file
    echo "$clean_mod_name $mod_id" >> "$output_file"
done

echo "Array text file has been created: $output_file"