#!/bin/bash

source .env

sshpass -p "$PASSWORD" ssh "$USERNAME"@"$IP" "ls ~/esquivelgor/*.{html,htm,php}"
sshpass -p "$PASSWORD" ssh "$USERNAME"@"$IP" "du -k ~/esquivelgor/*.{html,htm,php} | cut -f1"

exit 0 