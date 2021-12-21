#!/bin/bash

declare -a deps=("curl" "unzip" "rm")
declare -a patchfiles=("chrome_elf.dll" "config.ini")
SPOTIFY="$WINEPREFIX/drive_c/users/$(whoami)/AppData/Roaming/Spotify/"
TMPDIR=$(mktemp -d)

if (( $EUID == 0 )); then
    echo "Do not run this script as root."
    exit
fi

[[ -z "${WINEPREFIX}" ]] && WINEPREFIX="$HOME/.wine" || WINEPREFIX="${WINEPREFIX}"

echo "BlockTheSpot install script for Wine"
echo "BlockTheSpot: https://github.com/mrpond/BlockTheSpot/"
echo "Current Wineprefix: $WINEPREFIX"
cd $TMPDIR

for v in "${deps[@]}"
do
    if ! [ -x /usr/bin/$v ]; then
        echo "Dependency '$v' not found"
        exit
    fi
done

if ! [ -d "$SPOTIFY" ]; then
    echo "Spotify not found, make sure you're using correct wineprefix..."
    exit
fi

if [ "$1" == "uninstall" ]; then
    echo "Uninstalling BlockTheSpot..."
    for v in "${patchfiles[@]}"
    do
        rm "$SPOTIFY/$v"
    done
    mv "$SPOTIFY/chrome_elf_bak.dll" "$SPOTIFY/chrome_elf.dll"
    echo "Uninstalling completed."
    exit
fi

echo "Downloading BlockTheSpot..."
curl -OL "https://github.com/mrpond/BlockTheSpot/releases/latest/download/chrome_elf.zip"

echo "Extracting BlockTheSpot..."
unzip -d chrome_elf chrome_elf.zip

if [ -f "$SPOTIFY/chrome_elf.dll" ]; then
    echo "Backuping files..."
    mv "$SPOTIFY/chrome_elf.dll" "$SPOTIFY/chrome_elf_bak.dll"
fi

WINEPREFIX=$WINEPREFIX wineserver -k

echo "Patching Spotify..."
for v in "${patchfiles[@]}"
do
    cp "./chrome_elf/$v" "$SPOTIFY/$v"
done

echo "Patching completed."
