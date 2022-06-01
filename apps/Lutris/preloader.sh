#!/bin/bash
# Lutris pre-loader script, for allowing loading multiple pre-load scripts.

# Enabling debug will enable the script output.
DEBUG=1

execute_file () {
    # Just in case...
    chmod +x "$1"
    if [[ $DEBUG -eq 0 ]]; then
        nohup "$1" >/dev/null 2>&1 &
    else
        # No this is not as smart as you think...
        filename=$(echo "$1" | cut -d "/" -f3)
        nohup "$1" > ./logs/preloader_"$filename".log 2>&1 &
    fi
}

echo "Checking directory..."
mkdir -p ./preloader/ ./logs/
for file in ./preloader/*.*; do
    [ -e "$file" ] || continue
    echo "Found $file, loading..."
    execute_file "$file"
done

