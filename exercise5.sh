#!/bin/bash

# [1] Create a full copy of the directory "files" and move it to the ./backup/full 
# [1] Name the directory as backup_files_copy_date
# [1] "copy_date" is the date of backup (e.g., 20231006)

source .env

# Check if the date argument is passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <copy_date> <local/remote>"
    exit 1
fi

# Variables
COPY_DATE=$1
BACKUP=$2
SOURCE_DIR="files"
BACKUP_DIR="./backup/full/backup_files_$COPY_DATE"

# Create a full copy of the 'files' directory
if [ -d "$SOURCE_DIR" ]; then
    if [[ $BACKUP == "local" ]]; then
        tar cf "$BACKUP_DIR.tar" "$SOURCE_DIR"
        echo "Creating new full local backup into the folder: $BACKUP_DIR..."
    elif [[ $BACKUP == "remote" ]]; then
        tar cf "$BACKUP_DIR.tar" "$SOURCE_DIR"
        sshpass -p "$PASSWORD" scp -r "$BACKUP_DIR.tar" "$USERNAME@$IP:$BACKUP_DIR"
        rm "$BACKUP_DIR.tar"
        echo "Creating new full remote backup into the folder: $BACKUP_DIR..."
    else
        echo "Invalid backup type specified. Please use 'local' or 'remote'."
        exit 1
    fi
else
    echo "Directory $SOURCE_DIR does not exist."
    exit 1
fi

exit 0
