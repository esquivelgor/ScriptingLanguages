#!/bin/bash

source .env
source funcEx6.sh

TODAY=$(date +%Y%m%d)

CURRENT_DATE=$(date -d "$TODAY" +%s)

for i in {0..13}; do
    COPY_DATE=$(date -d "@$CURRENT_DATE" +%Y%m%d)
    DAY_OF_WEEK=$(date -d "@$CURRENT_DATE" +%u) # 1 = Monday, 7 = Sunday

    if [ "$DAY_OF_WEEK" -eq 1 ]; then
        # Full backup on Monday
        echo "Creating full backup for date: $COPY_DATE"
        ./exercise6.sh "$COPY_DATE" "local" # Modify "local" to "remote" if needed
    elif [ "$DAY_OF_WEEK" -eq 3 ] || [ "$DAY_OF_WEEK" -eq 6 ]; then
        # Incremental backup on Wednesday and Saturday
        echo "Creating incremental backup for date: $COPY_DATE"
        ./exercise6.sh "$COPY_DATE" "local" # Modify "local" to "remote" if needed
    fi

    # Increment the current date by one day
    CURRENT_DATE=$((CURRENT_DATE + 86400)) # 86400 seconds in a day
done
