#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <action> <backup_type> <date>"
    echo "Action: destroy or archive"
    echo "Backup Type: full or incremental"
    echo "Date Format: YYYYMMDD"
    exit 1
fi

# Variables
ACTION=$1
BACKUP_TYPE=$2
SPECIFIED_DATE=$3
BACKUP_DIR="./backup/full/"
ARCHIVE_DIR="./backup/archive/"
SPECIFIED_DATE_TIMESTAMP=$(date -d "$SPECIFIED_DATE" +%s)
ONE_WEEK_AGO_TIMESTAMP=$((SPECIFIED_DATE_TIMESTAMP - 604800)) # 604800 seconds = 1 week

# Validate action
if [[ "$ACTION" != "destroy" && "$ACTION" != "archive" ]]; then
    echo "Invalid action: $ACTION. Use 'destroy' or 'archive'."
    exit 1
fi

# Validate backup type
if [[ "$BACKUP_TYPE" != "full" && "$BACKUP_TYPE" != "incremental" ]]; then
    echo "Invalid backup type: $BACKUP_TYPE. Use 'full' or 'incremental'."
    exit 1
fi

# Find backups to process
if [ "$BACKUP_TYPE" == "full" ]; then
    BACKUP_PATTERN="backup_files_*" # Full backups pattern
else
    BACKUP_PATTERN="incremental_files_*" # Incremental backups pattern
fi

# Create the archive directory if archiving
if [ "$ACTION" == "archive" ]; then
    mkdir -p "$ARCHIVE_DIR"
fi

# Process each backup
for BACKUP in "$BACKUP_DIR"/$BACKUP_PATTERN; do
    if [ ! -e "$BACKUP" ]; then
        echo "No backups found matching pattern: $BACKUP_PATTERN"
        exit 0
    fi

    BACKUP_DATE=$(echo "$BACKUP" | grep -oE '[0-9]{8}')
    BACKUP_TIMESTAMP=$(date -d "$BACKUP_DATE" +%s)

    if [ "$BACKUP_TIMESTAMP" -lt "$ONE_WEEK_AGO_TIMESTAMP" ]; then
        if [ "$ACTION" == "destroy" ]; then
            echo "Destroying backup: $BACKUP"
            rm -rf "$BACKUP"
        elif [ "$ACTION" == "archive" ]; then
            echo "Archiving backup: $BACKUP"
            mv "$BACKUP" "$ARCHIVE_DIR"
        fi
    fi
done

echo "Completed $ACTION operation for $BACKUP_TYPE backups older than a week."
exit 0
