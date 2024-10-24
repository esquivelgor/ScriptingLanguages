#!/bin/bash

createFullBackup() {
    BACKUP=$1
    SOURCE_DIR=$2
    BACKUP_DIR=$3
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
} 

incrementalBackup() {
    BACKUP=$1
    SOURCE_DIR=$2
    BACKUP_DIR=$3
    LAST_FULL_BACKUP=$4
    SNAPSHOT_FILE="./backup/full/snapshot.snar"  # Same snapshot file used for tracking
    DAILY_BACKUP_DIR="./backup/daily/"  # Directory for daily incremental backups

    if [ -d "$SOURCE_DIR" ]; then
        if [[ $BACKUP == "local" ]]; then
            echo "Creating local incremental backup..."

            if [ ! -f "$SNAPSHOT_FILE" ]; then
                echo "No snapshot found. Creating a full backup."
                tar --listed-incremental="$SNAPSHOT_FILE" -cf "$BACKUP_DIR.tar" "$SOURCE_DIR"
            else
                echo "Using snapshot file for incremental backup."
                tar --listed-incremental="$SNAPSHOT_FILE" -cf "$BACKUP_DIR.tar" "$SOURCE_DIR"
            fi
            
            echo "Local incremental backup created: $BACKUP_DIR.tar"

        elif [[ $BACKUP == "remote" ]]; then
            echo "Creating remote incremental backup..."

            # Check if snapshot exists
            if [ ! -f "$SNAPSHOT_FILE" ]; then
                echo "No snapshot found. Creating a full backup on remote."
                tar --listed-incremental="$SNAPSHOT_FILE" -cf "$BACKUP_DIR.tar" "$SOURCE_DIR"
            else
                echo "Using snapshot file for remote incremental backup."
                tar --listed-incremental="$SNAPSHOT_FILE" -cf "$BACKUP_DIR.tar" "$SOURCE_DIR"
            fi

            # Transfer the backup file to the remote server's daily backup directory
            sshpass -p "$PASSWORD" scp -r "$BACKUP_DIR.tar" "$USERNAME@$IP:$DAILY_BACKUP_DIR"
            rm "$BACKUP_DIR.tar"
            echo "Remote incremental backup created in the folder: $DAILY_BACKUP_DIR"

        else
            echo "Invalid backup type specified. Please use 'local' or 'remote'."
            exit 1
        fi
    else
        echo "Directory $SOURCE_DIR does not exist."
        exit 1
    fi
}
