#!/bin/bash

declare -a deps=("curl" "unzip" "rm" "7z" "python3")
declare -a patchfiles=("chrome_elf.dll" "config.ini")

if (( $EUID == 0 )); then
    echo "Do not run this script as root."
    exit
fi

adPatchScript=$(cat << EOF
#!/usr/bin/python3
import re
from pathlib import Path

print("Patching xpui.js...")
xpui = Path("./xpui/xpui.js")
xpui_content = xpui.read_text(encoding="utf-8")
replace_ad = re.sub(r"(\.ads\.leaderboard\.isEnabled)(}|\))", r"\1&&false\2", xpui_content)
replace_upgrade = re.sub(r"\.createElement\([^.,{]+,{onClick:[^.,]+,className:[^.]+\.[^.]+\.UpgradeButton}\),[^.(]+\(\)", "", replace_ad)
xpui.write_text(replace_upgrade, encoding="utf-8")
EOF
)

[[ -z "${WINEPREFIX}" ]] && WINEPREFIX="$HOME/.wine" || WINEPREFIX="${WINEPREFIX}"

SPOTIFY="$WINEPREFIX/drive_c/users/$(whoami)/AppData/Roaming/Spotify/"
SPOTIFY_APPS="$SPOTIFY/Apps/"
xpuiBundlePath="$SPOTIFY_APPS/xpui.spa"
xpuiUnpackedPath="$SPOTIFY_APPS/xpui/xpui.js"

echo "BlockTheSpot install script for Spotify (Wine version)"
echo "BlockTheSpot: https://github.com/mrpond/BlockTheSpot/"
echo "Current Wineprefix: $WINEPREFIX"
TMPDIR=$(mktemp -d)
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
    if [ -f "$SPOTIFY/chrome_elf_bak.dll" ]; then
        echo "Uninstalling BlockTheSpot..."
        for v in "${patchfiles[@]}"
        do
            rm "$SPOTIFY/$v"
        done
        mv "$SPOTIFY/chrome_elf_bak.dll" "$SPOTIFY/chrome_elf.dll"
        echo "Uninstalling xpui patch if found..."
        mv "$xpuiBundlePath.bak" "$xpuiBundlePath"
    fi
    echo "Uninstalling BlockTheSpot (IF INSTALLED) completed."
    exit
fi

echo "Downloading BlockTheSpot..."
curl -OL "https://github.com/mrpond/BlockTheSpot/releases/latest/download/chrome_elf.zip"

echo "Extracting BlockTheSpot..."
unzip -d chrome_elf chrome_elf.zip

if [ -f "$SPOTIFY/chrome_elf.dll" ] && ! [ -f "$SPOTIFY/chrome_elf_bak.dll" ]; then
    echo "Backuping files..."
    mv "$SPOTIFY/chrome_elf.dll" "$SPOTIFY/chrome_elf_bak.dll"
fi

WINEPREFIX=$WINEPREFIX wineserver -k

echo "Patching Spotify..."
for v in "${patchfiles[@]}"
do
    cp "./chrome_elf/$v" "$SPOTIFY/$v"
done

read -p "Do you want to remove ad placeholder and upgrade button? (y/n) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    if [ -f "$xpuiBundlePath" ]; then
        echo "Patching xpui.spa..."
        if ! [ -f "$xpuiBundlePath.bak" ]; then
            mv "$xpuiBundlePath" "$xpuiBundlePath.bak"
        fi
        unzip -d xpui "$xpuiBundlePath.bak"
    fi
    echo "$adPatchScript" > "./patch.py"
    python3 ./patch.py
    7z a xpui.zip "./xpui/*"
    mv xpui.zip $xpuiBundlePath
fi

echo "Patching completed, open Spotify and enjoy :D"
echo "Temporary directory used $TMPDIR"
