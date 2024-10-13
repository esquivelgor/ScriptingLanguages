#!/bin/bash

source .env
source func.sh

sshpass -p "$PASSWORD" ssh "$USERNAME"@"$IP" "cat /home/stud/stud/$1" > output.txt

# Array to store lines
lines=()

# Read each line into the array
while IFS= read -r line; do
    lines+=("$line")
done < output.txt

# Process each line stored in the array
echo "Processing login names and passwords..."
for line in "${lines[@]}"; do
    IFS=';'
    read -ra fields <<< "$line" # Read the line into an array of fields
    fullName=${fields[1]}
    
    IFS=' '
    read -ra name <<< "$fullName"
    vardas=${name[1]}
    pavarde=${name[0]}
    unset   
    loginName="${vardas:0:4}${pavarde:0:4}"
    
    echo "${loginName} $(gen_pass 10)"
done
exit 0