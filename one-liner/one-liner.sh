#!/bin/bash

arraySource="LAE-classic.txt"
outputFile="classic-config.txt"

#####################################################################
#####################################################################
#####################################################################

echo "     __    ___    ______     ___                   ___   _____ ";
echo "    / /   /   |  / ____/    /   |  _________ ___  /   | |__  / ";
echo "   / /   / /| | / __/______/ /| | / ___/ __ \__ \/ /| |  /_ <  ";
echo "  / /___/ ___ |/ /__/_____/ ___ |/ /  / / / / / / ___ |___/ /  ";
echo " /_____/_/__|_/_____/    /_/  |_/_/_ /_/ /_/ /_/_/  |_/____/   ";
echo "           / __ \____  ___        / (_)___  ___  _____         ";
echo "          / / / / __ \/ _ \______/ / / __ \/ _ \/ ___/         ";
echo "         / /_/ / / / /  __/_____/ / / / / /  __/ /             ";
echo "         \____/_/ /_/\___/     /_/_/_/ /_/\___/_/              ";
echo "                                                               ";
echo "                    written by V0LD3M0R7                       ";
sleep 3

# Define the separator, prefix, and suffix for array elements
prefix='mods="'
separator='\;mods/'  # Literal backslash + semicolon + "mods/"
suffix='"'

# Read the file into an array (assuming each line is an array element)
mapfile -t arr < "$arraySource"

# Initialize result with the last element of the first array item
result="${arr[0]##* }"

# Loop through the rest of the array, appending only the last element of each item
for (( i=1; i<${#arr[@]}; i++ )); do
    result+="${separator}${arr[i]##* }"
done

# Combine the resulting string
output="${prefix}${result}${suffix}"

# Generate the output text file
echo "$output" > "$outputFile"
echo ""
echo "Result saved to $outputFile"
