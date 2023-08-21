#!/bin/bash
# Lutris pre-loader script, for allowing loading multiple pre-load scripts.

# Enabling debug will enable the script output.

# Folder path (relative to Lutris prefix directory)
FOLDER="${PRELOADER_PATH:-"./preloader"}"
DEBUG="${PRELOADER_DEBUG:-0}"

execute_file () {
    # Just in case...
    chmod +x "$1"
    if [[ $DEBUG -eq 0 ]]; then
        nohup "$1" >/dev/null 2>&1 &
    else
        fullfile="$1"
        filename="${fullfile##*/}"
        nohup "$1" > ./logs/"$FOLDER"_"$filename".log 2>&1 &
    fi
}

if [[ $DEBUG -ne 0 ]]; then
    echo "!!!DEBUGGING ENABLED!!!"
    echo "Debug log may leak your sensitive information, use with caution."
    echo "!!!DEBUGGING ENABLED!!!"
    mkdir -p "$FOLDER" ./logs/
fi
echo "Checking directory..."
for file in "$FOLDER"/*.*; do
    [ -e "$file" ] || continue
    echo "Found $file, loading..."
    execute_file "$file"
done

