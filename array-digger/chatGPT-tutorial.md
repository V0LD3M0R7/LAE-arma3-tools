To create an array text file with the mod names and IDs from the HTML file, you can use a script to parse the HTML content and extract the relevant information.

Here's a simple Bash script that will extract the mod names `(from <td data-type="DisplayName">)` and mod IDs (from the links `<a href="https://steamcommunity.com/sharedfiles/filedetails/?id=<ID>)` and create an array text file with two elements per line (mod name and mod ID):

```bash
#!/bin/bash

# Input HTML file
input_file="your_html_file.html"
output_file="mod_names_and_ids.txt"

# Extract mod names and IDs and save to output file
grep -oP '(?<=<td data-type="DisplayName">).*?(?=</td>)' "$input_file" | while read -r mod_name; do
    # Extract the mod ID from the corresponding <a href> link
    mod_id=$(grep -oP "(?<=<td data-type=\"DisplayName\">$mod_name</td>.*?id=)\d+" "$input_file")
    
    # Write mod name and ID to the output file
    echo "$mod_name $mod_id" >> "$output_file"
done

echo "Array text file has been created: $output_file"
```

How the script works:
1. The script searches for each mod's name using grep with a Perl regular expression (-P), matching everything between `<td data-type="DisplayName"> and </td>`.
2. For each mod name found, it searches the same file for the corresponding mod ID using another grep command, extracting the ID from the URL in the `<a href="...">` tags.
3. Both the mod name and ID are written to the `mod_names_and_ids.txt` file, with each pair on a new line.

**EXAMPLE OUTPUT**

```csharp
[CYTECH] Guns, Uniforms, and Vehicles 3032739214
ace 463939057
Advanced Rappelling 713709341
Advanced Sling Loading 615007497
Advanced Towing 639837898
Advanced Urban Rappelling 730310357
```

Make sure to replace `your_html_file.html` with the actual name of your HTML file. The output will be saved to `mod_names_and_ids.txt`.

---
**the script has to remove all special characters in the element and also replace all spaces with underscores**

To modify the script so that it removes all special characters (except alphanumeric characters and spaces) and replaces all spaces with underscores in the mod names, you can use sed or a similar tool to perform the cleanup on each mod name before writing it to the output file.

Here’s the updated script that performs these transformations:

```bash
#!/bin/bash

# Input HTML file
input_file="your_html_file.html"
output_file="mod_names_and_ids.txt"

# Extract mod names and IDs and save to output file
grep -oP '(?<=<td data-type="DisplayName">).*?(?=</td>)' "$input_file" | while read -r mod_name; do
    # Clean the mod name: remove special characters and replace spaces with underscores
    clean_mod_name=$(echo "$mod_name" | sed 's/[^a-zA-Z0-9 ]//g' | sed 's/ /_/g')

    # Extract the mod ID from the corresponding <a href> link
    mod_id=$(grep -oP "(?<=<td data-type=\"DisplayName\">$mod_name</td>.*?id=)\d+" "$input_file")
    
    # Write clean mod name and mod ID to the output file
    echo "$clean_mod_name $mod_id" >> "$output_file"
done

echo "Array text file has been created: $output_file"
```

How the script works:

1. The first `sed` command removes any character that is not alphanumeric or a space by replacing everything except `[a-zA-Z0-9 ]` with an empty string `(s/[^a-zA-Z0-9 ]//g)`.
2. The second `sed` command replaces all spaces with underscores `(s/ /_/g)`.
3. The rest of the script works as before to extract the mod names and IDs, now using the cleaned-up mod names.

**Example output:**

Given the input:

```html
<td data-type="DisplayName">[CYTECH] Guns, Uniforms, and Vehicles</td>
<td data-type="DisplayName">Advanced Rappelling</td>
```

The output will look like:

```
CYTECH_Guns_Uniforms_and_Vehicles 3032739214
Advanced_Rappelling 713709341
```

This version of the script ensures that all special characters are removed, and spaces are replaced with underscores.

**also can we incorporate this lowercasing script before creating the array file? :**
```
#!/bin/bash
depth=0
for x in $(find . -type d | sed "s/[^/]//g")
do
if [ ${depth} -lt ${#x} ]
then
   let depth=${#x}
fi
done
echo "the depth is ${depth}"
for ((i=1;i<=${depth};i++))
do
  for x in $(find . -maxdepth $i | grep [A-Z])
  do
    mv $x $(echo $x | tr 'A-Z' 'a-z')
  done
done
```

Yes, you can integrate the lowercasing script into the array file creation process. The idea would be to first convert all the mod names to lowercase before creating the array text file.

Here's how you can combine your original script with the lowercase script and ensure the mod names are converted to lowercase before processing:

```bash
#!/bin/bash

# Input HTML file
input_file="your_html_file.html"
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
```

How the script works:

1. Lowercasing Function (convert_to_lowercase): This function takes a string and converts it to lowercase using tr 'A-Z' 'a-z'. It is called after the mod name is cleaned (i.e., special characters removed and spaces replaced with underscores).
2. Processing Mod Names: The mod names are first cleaned of special characters and spaces are replaced with underscores. Then, they are passed through the convert_to_lowercase function to make the mod names lowercase before writing them to the output file.
3. Extracting Mod IDs: The script still extracts the mod IDs from the links as before and pairs them with the cleaned, lowercased mod names in the output file.

Example output (with lowercased mod names):
```
cytech_guns_uniforms_and_vehicles 3032739214
ace 463939057
advanced_rappelling 713709341
advanced_sling_loading 615007497
advanced_towing 639837898
advanced_urban_rappelling 730310357
```

In this version of the script, the mod names will be cleaned, special characters removed, spaces replaced with underscores, and then converted to lowercase before they are written to the final array text file. This ensures the array file contains consistent, lowercase mod names.
