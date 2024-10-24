#!/bin/bash

# Create the 'files' directory
mkdir -p files

# Create 10 files with different formats
touch files/document1.txt
touch files/spreadsheet1.csv
touch files/image1.jpg
touch files/archive1.zip
touch files/script1.sh
touch files/presentation1.pptx
touch files/audio1.mp3
touch files/video1.mp4
touch files/data1.json
touch files/report1.pdf

# Modify the creation date for each file using touch with different dates
touch -t 202401010101 files/document1.txt       # January 1, 2024
touch -t 202402020202 files/spreadsheet1.csv    # February 2, 2024
touch -t 202403030303 files/image1.jpg          # March 3, 2024
touch -t 202404040404 files/archive1.zip        # April 4, 2024
touch -t 202405050505 files/script1.sh          # May 5, 2024
touch -t 202406060606 files/presentation1.pptx  # June 6, 2024
touch -t 202407070707 files/audio1.mp3          # July 7, 2024
touch -t 202408080808 files/video1.mp4          # August 8, 2024
touch -t 202409090909 files/data1.json          # September 9, 2024
touch -t 202410101010 files/report1.pdf         # October 10, 2024

echo "10 files created in the 'files' directory with different formats and dates."
