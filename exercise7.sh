#!/bin/bash

# Write a script in exercise7.sh that allows you to restore files up to the date specified by the
# argument. Use the scripts created in Exercise1 and Exercise2.

# Check if the date argument is passed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <restore_date>"
    exit 1
fi

# Variables
RESTORE_DATE=$1
BACKUP_DIR="./backup/full/"
RESTORE_TARGET_DIR="./restored_files/"
RESTORE_DATE_TIMESTAMP=$(date -d "$RESTORE_DATE" +%s)

# Create the target restore directory if it doesn't exist
mkdir -p "$RESTORE_TARGET_DIR"

# Find the latest backup that is on or before the specified date
LATEST_BACKUP=$(find "$BACKUP_DIR" -maxdepth 1 -name "backup_files_*" | sort | grep -E "[0-9]{8}" | while read -r backup; do
    BACKUP_DATE=$(echo "$backup" | grep -oE '[0-9]{8}')
    BACKUP_TIMESTAMP=$(date -d "$BACKUP_DATE" +%s)
    
    if [ "$BACKUP_TIMESTAMP" -le "$RESTORE_DATE_TIMESTAMP" ]; then
        echo "$backup"
    fi
done | tail -n 1)

# Check if a valid backup was found
if [ -z "$LATEST_BACKUP" ]; then
    echo "No backups found before or on the specified date: $RESTORE_DATE"
    exit 1
fi

# Restore the files from the latest backup
echo "Restoring files from backup: $LATEST_BACKUP"
tar -xvf "$LATEST_BACKUP" -C "$RESTORE_TARGET_DIR"

echo "Files restored to $RESTORE_TARGET_DIR"
exit 0
