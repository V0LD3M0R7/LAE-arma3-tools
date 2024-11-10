#!/bin/bash

## ARMA 3 WORKSHOP DIRECTORY ##
modSource="/home/vitpeukert/Disky/kingston-500/SteamLibrary/steamapps/workshop/content/107410/"
## COPY OUTPUT DIRECTORY ##
outDir="/home/vitpeukert/LAE/modpack_dir/"
## NUMBER OF MODS IN MODPACK ##
count="53"
## MODPACK ARRAY FILE ##
file="LAE-classic.txt"

#######################################################
#######################################################
#######################################################


echo "    __    ___    ______     ___                   ___   _____       __  __          __      __           ";
echo "   / /   /   |  / ____/    /   |  _________ ___  /   | |__  /      / / / /___  ____/ /___ _/ /____  _____";
echo "  / /   / /| | / __/______/ /| | / ___/ __ \__ \/ /| |  /_ <______/ / / / __ \/ __  / __ \/ __/ _ \/ ___/";
echo " / /___/ ___ |/ /__/_____/ ___ |/ /  / / / / / / ___ |___/ /_____/ /_/ / /_/ / /_/ / /_/ / /_/  __/ /    ";
echo "/_____/_/  |_/_____/    /_/  |_/_/  /_/ /_/ /_/_/  |_/____/      \____/ .___/\__,_/\__,_/\__/\___/_/     ";
echo "    ____                                                          __ /_/__                               ";
echo "   / __/___  _____   ________  ______   _____  _____   ____ _____/ /___/ /___  ____  _____               ";
echo "  / /_/ __ \/ ___/  / ___/ _ \/ ___/ | / / _ \/ ___/  / __ \/ __  / __  / __ \/ __ \/ ___/               ";
echo " / __/ /_/ / /     (__  )  __/ /   | |/ /  __/ /     / /_/ / /_/ / /_/ / /_/ / / / (__  )                ";
echo "/_/  \____/_/     /____/\___/_/    |___/\___/_/      \__,_/\__,_/\__,_/\____/_/ /_/____/                 ";
echo "                                                                                                         ";
echo "";
sleep 3

# Reading the modpack file into an array
mapfile -t modArray < "$file"
recount=$((count - 1))

# Copying folders to outputDir using rsync with progress feedback
for n in $(seq 0 "$recount"); do
    modFolder="${modArray[$n]%% *}"
    if [[ -d "$modSource$modFolder" ]]; then
        echo "Copying $modFolder to $outDir..."
        rsync -a --info=progress2 "$modSource$modFolder" "$outDir"
    else
        echo "Warning: Source folder $modSource$modFolder does not exist."
    fi
done

cd "$outDir" || exit 1

# Renaming copied folders based on the second part of array entries (mod names)
for n in $(seq 0 "$recount"); do
    modFolder="${modArray[$n]%% *}"
    modName="${modArray[$n]##* }"
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

echo "Copying and renaming complete";
sleep 3
exit 0
