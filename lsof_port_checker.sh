#!/bin/bash
output_file="open_ports.txt"
> "$output_file"
echo "Open TCP Ports:" >> "$output_file"
lsof -iTCP -sTCP:LISTEN -P -n | awk '{print $1, $9}' | grep -Eo ':[0-9]+' | sort -u >> "$output_file"
echo -e "\nOpen UDP Ports:" >> "$output_file"
lsof -iUDP -P -n | awk '{print $1, $9}' | grep -Eo ':[0-9]+' | sort -u >> "$output_file"
cat $output_file
rm $output_file
