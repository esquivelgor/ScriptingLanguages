#!/bin/bash

# [1] allows creating a daily incremental copy of the directory "files" (creating a full or incremental copy can be done in separate functions).
# [1] Name the directory as backup_files_copy_date
# [1] if no full copy has been created, the user is informed and a full copy is created
# [1] An incremental copy can be created only if the full copy is not older that one week old otherwise a full copy is created
# [1] Backup directories must be named as backup_files_copy_date
# [1] Additional copies must be transferred to the remote server directory ./backup/daily

source .env
source funcEx6.sh

# Check if the date argument is passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <copy_date> <local/remote>"
    exit 1
fi

# Variables
COPY_DATE=$1
BACKUP=$2
SOURCE_DIR="files"
BACKUP_DIR_="./backup/full/"
BACKUP_DIR="./backup/full/backup_files_$COPY_DATE"

echo "Looking for backups..."
if [ -d "$BACKUP_DIR_" ] && [ -n "$(ls -A "$BACKUP_DIR_")" ]; then
    echo "Reviewing backups..."

    LAST_FULL_BACKUP=$(find $BACKUP_DIR_ -maxdepth 1 -name "backup_files_*" | sort | tail -n 1)
    FULL_BACKUP_DATE=$(echo "$LAST_FULL_BACKUP" | grep -oE '[0-9]{8}') 
    FULL_BACKUP_TIMESTAMP=$(date -d "$FULL_BACKUP_DATE" +%s)
    ONE_WEEK_AGO=$(date -d "$COPY_DATE -7 days" +%s)
    
    if [ "$FULL_BACKUP_TIMESTAMP" -lt "$ONE_WEEK_AGO" ]; then
        echo "Full backup is older than one week, creating a new full backup..."
        createFullBackup $BACKUP $SOURCE_DIR $BACKUP_DIR
        exit 0
    else 
        echo "Creating an incremental backup..."
        incrementalBackup $BACKUP $SOURCE_DIR $BACKUP_DIR $LAST_FULL_BACKUP
        exit 0
    fi

    exit 0
else
    echo "There are no backups in the system."
    createFullBackup $BACKUP $SOURCE_DIR $BACKUP_DIR
fi

exit 0
