#!/bin/bash

source .env

# counts the sum of argument elements (not the quantity!)
sum() {
    local count=0
    for _ in "$@"; do
        count=$((count + 1))
    done
    echo "Count of args elements: $count"
}

# returns a list of files, login name and file extensions are passed as arguments),
file_array() {
    sshpass -p "$PASSWORD" ssh "$1"@"$IP" "ls ~/esquivelgor/$2"
}

# returns file sizes, given a login name and file extensions)
file_sizes() {
    sshpass -p "$PASSWORD" ssh "$1"@"$IP" "du -k ~/esquivelgor/$2 | cut -f1"
}

gen_pass() { # password generation function
    [ "$2" == "0" ] && CHAR="[:alnum:]" || CHAR="[:graph:]"
    cat /dev/urandom | tr -cd "$CHAR" | head -c ${1:-32}
    echo
}