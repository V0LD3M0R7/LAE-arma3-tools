#!/bin/bash

# Read configuration from TOML file
configFile="config.toml"

# Function to parse TOML values
get_toml_value() {
    local key=$1
    grep -Po "(?<=^$key = ).*" "$configFile" | sed 's/^"//;s/"$//'
}

# Set values from TOML file
modSource=$(get_toml_value "paths.modSource")
outDir=$(get_toml_value "paths.outDir")
file=$(get_toml_value "modpack.file")

echo "    __    ___    ______     ___                   ___   _____    __  __          __      __           ";
echo "   / /   /   |  / ____/    /   |  _________ ___  /   | |__  /   / / / /___  ____/ /___ _/ /____  _____";
echo "  / /   / /| | / __/______/ /| | / ___/ __ \__ \/ /| |  /_ <   / / / / __ \/ __  / __ \/ __/ _ \/ ___/";
echo " / /___/ ___ |/ /__/_____/ ___ |/ /  / / / / / / ___ |___/ /  / /_/ / /_/ / /_/ / /_/ / /_/  __/ /    ";
echo "/_____/_/  |_/_____/    /_/  |_/_/  /_/ /_/ /_/_/  |_/____/   \____/ .___/\__,_/\__,_/\__/\___/_/     ";
echo "         ____                                                     /_/  __    __                       ";
echo "        / __/___  _____   ________  ______   _____  _____   ____  ____/ /___/ /___  ____  _____       ";
echo "       / /_/ __ \/ ___/  / ___/ _ \/ ___/ | / / _ \/ ___/  / __ \/ __  / __  / __ \/ __ \/ ___/       ";
echo "      / __/ /_/ / /     (__  )  __/ /   | |/ /  __/ /     / /_/ / /_/ / /_/ / /_/ / / / (__  )        ";
echo "     /_/  \____/_/     /____/\___/_/    |___/\___/_/      \__,_/\__,_/\__,_/\____/_/ /_/____/         ";
echo "                                                                                                      ";
echo "                                        written by V0LD3M0R7                                          ";
sleep 3

count=$(wc -l < "$file")

# Print of defined variables
echo "Mod Source: $modSource"
echo "Output Directory: $outDir"
echo "Number of Mods: $count"
echo "Modpack File: $file"
sleep 3

# Reading the modpack file into an array
mapfile -t modArray < "$file"w
recount=$((count - 1))

# Copying folders to outputDir using rsync with progress feedback
# modFolder is based on first element of modArray
for n in $(seq 0 "$recount"); do
    modFolder="${modArray[$n]##* }"
    if [[ -d "$modSource$modFolder" ]]; then
        echo "Copying $modFolder to $outDir..."
        rsync -a --info=progress2 "$modSource$modFolder" "$outDir"
    else
        echo "Warning: Source folder $modSource$modFolder does not exist."
    fi
done

cd "$outDir" || exit 1

# Renaming copied folders based on the first element of modArray entries (mod names)
for n in $(seq 0 "$recount"); do
    modName="${modArray[$n]%% *}"
    modFolder="${modArray[$n]##* }"
    if [[ -d "$modFolder" ]]; then
        mv "$modFolder" "$modName"
    else
        echo "Warning: Folder $modFolder does not exist in $outDir."
    fi
done

# Convert all file and directory names to lowercase
depth=0
for x in $(find . -type d | sed "s/[^/]//g"); do
    if [ ${depth} -lt ${#x} ]; then
        let depth=${#x}
    fi
done
echo "the depth is ${depth}"
for ((i=1;i<=${depth};i++)); do
    for x in $(find . -maxdepth $i | grep [A-Z]); do
        mv "$x" "$(echo "$x" | tr 'A-Z' 'a-z')"
    done
done

# Final messege
echo ""
echo "Copying and renaming complete";
sleep 3
exit 0
