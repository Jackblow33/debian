#!/bin/bash


# Set the directory where the files are located and define the file path
USR=$(logname)
DIR="/home/$USR/debian/pkgs-tools"
FULL_PKGS="$DIR/full_pkgs.list"
BASE_PKGS="$DIR/base_pkgs.list"
OUTPUT_FILE="$DIR/pkgs.list"

# Check if the input files exist
if [[ ! -f "$FULL_PKGS" ]]; then
    echo "Error: $FULL_PKGS does not exist."
    exit 1
fi

if [[ ! -f "$BASE_PKGS" ]]; then
    echo "Error: $BASE_PKGS does not exist."
    exit 1
fi

# Normalize the entries by trimming whitespace and converting to lowercase
# and then use 'grep' to filter out entries in base_pkgs.list from full_pkgs.list
awk '{$1=$1; print tolower($0)}' "$BASE_PKGS" > /tmp/normalized_base_pkgs.list
awk '{$1=$1; print tolower($0)}' "$FULL_PKGS" > /tmp/normalized_full_pkgs.list

# Use grep to filter out entries
grep -vxFf /tmp/normalized_base_pkgs.list /tmp/normalized_full_pkgs.list > "$OUTPUT_FILE"

# Check if the output file was created successfully
if [[ $? -eq 0 ]]; then
    echo "Comparison complete. Results saved in $OUTPUT_FILE."
    echo "Number of packages in pkgs.list: $(wc -l < "$OUTPUT_FILE")"
else
    echo "Error occurred while generating the output file."
fi

# Clean up temporary files
rm /tmp/normalized_base_pkgs.list /tmp/normalized_full_pkgs.list
