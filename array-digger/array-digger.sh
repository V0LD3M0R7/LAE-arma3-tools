#!/bin/bash

# Input HTML file and output file
input_file="arma3-modpack.html"
output_file="mod_array.txt"

# Clear output file if it exists
> "$output_file"

echo "       __    ___    ______     ___                   ___   _____   "
echo "      / /   /   |  / ____/    /   |  _____________  /   | |__  /   "
echo "     / /   / /| | / __/______/ /| | / ___/ __  __ \/ /| |  /_ <    "
echo "    / /___/ ___ |/ /__/_____/ ___ |/ /  / / / / / / ___ |___/ /    "
echo "   /_____/_/  |_/_____/    /_/  |_/_/  /_/ /_/ /_/_/  |_/____/     "
echo "   ____  ______________  __  __   ____/ (_)___  ___   ___  _____   "
echo "  / __ \/ ___/ __// __ \/ / / /  / ___ / / __ \/ __\ / _ \/ ___/   "
echo " / /_/ / /  / /  / /_/ / /_/ /  / /_/ / / /_/ / /_/ /  __/ /       "
echo " \__,_/_/  /_/   \__,_/\__, /   \__,_/_/\__, /\__, /\___/_/        "
echo "                      /____/           /____//____/                "
echo ""
echo "                      written by V0LD3M0R7                         "

# Parse HTML file to extract mod names and IDs
awk '
    /<td data-type="DisplayName">/ {
        # Extract the mod name between the tags
        match($0, /<td data-type="DisplayName">([^<]*)<\/td>/, name)
        mod_name = name[1]

        # Clean and lowercase the mod name
        gsub(/[^a-zA-Z0-9 ]/, "", mod_name)       # Remove non-alphanumeric characters except spaces
        gsub(/[[:space:]]+/, "_", mod_name)       # Replace spaces or multiple spaces with a single underscore
        mod_name = tolower(mod_name)
    }
    /<a href=.*id=[0-9]+/ {
        # Extract the mod ID from the link
        match($0, /id=([0-9]+)/, id)
        mod_id = id[1]

        # Output to the file only if both mod_name and mod_id are set, with @ before mod_name
        if (mod_name && mod_id) {
            print "@" mod_name " " mod_id >> "'"$output_file"'"
            mod_name = ""; mod_id = "" # Reset for the next iteration
        }
    }
' "$input_file"

echo "";
echo "Array text file has been created: $output_file"
exit
