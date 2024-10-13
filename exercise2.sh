#!/bin/bash

source .env
source func.sh

echo "--------- Sum Function ---------"
sum 10 1 21 2

echo "--------- File Array Function ---------"
file_array $USERNAME '*.{html,htm,php}'

echo "--------- File Sizes Function ---------"
file_sizes $USERNAME '*.{html,htm,php}'

exit 0 