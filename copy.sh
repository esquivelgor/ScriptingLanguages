#!/bin/bash

# Server
# sshpass -p "$PASSWORD" ssh "$USERNAME"@"$IP" "ls public_html/*.{html,htm,php} > output.txt"
# Local
ls -l public_html/*.{html,htm,pdf} > out.txt

lines=()

# Read each line into the array
while IFS= read -r line; do
    lines+=("$line")
done < out.txt

echo "Processing each data title..."
for line in "${lines[@]}"; do
    IFS=' '
    read -ra fields <<< "$line" # Read the line into an array of fields
    date=${fields[5]}
    file=${fields[8]}
    
    IFS='/'
    read -ra filePath <<< "$file"
    f=${filePath[1]}
    unset

    path="root/$date"    
    if [ ! -d "$path" ]; then
        mkdir -p "$path"
        echo "Folder $path created."
    fi   

    echo "Moving file ${file} to root/${date}/${f}" 
    cp "$file" "root/${date}/${f}"
    
done

echo "Analyzing each folder..."

months=()
while IFS= read -r dir; do
    months+=("$dir")
done < <(ls root)

for dir in "${months[@]}"; do
    echo "Folder ${dir}"
    touch "root/$dir/statistics.txt"
    
    files=()
    while IFS= read -r file; do
        files+=("$file")
    done < <(ls "root/$dir")

    len=${#files[@]}
    size=$(du -k "root/$dir" | cut -f1)
    files=$(ls root/$dir)
    echo "Number of files: ${len}" >> "root/$dir/statistics.txt"
    echo "File space: ${size} kilobytes" >> "root/$dir/statistics.txt"
    echo "" >> "root/$dir/statistics.txt"
    echo "Files:" >> "root/$dir/statistics.txt"
    echo "$files" >> "root/$dir/statistics.txt"
    
done
exit 0