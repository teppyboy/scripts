#!/bin/bash

echo "Cities: Skylines no launcher patch (dowser.exe replacing method)"
echo "Type your Cities:Skylines location (default is $HOME/.local/share/Steam/steamapps/common/Cities_Skylines/):"
read CS_LOCATION
[ -z "$CS_LOCATION" ] && CS_LOCATION="$HOME/.local/share/Steam/steamapps/common/Cities_Skylines/"
echo "Changing directory..."
cd "$CS_LOCATION"
PROTON6=false
for steam_apps in ./../*/; do
    if [[ $steam_apps == *"Proton 6"* || $steam_apps == *"Proton - Experimental"* ]]; then
        echo "debug"
        PROTON6=true
        break
    fi
done
if [[ $PROTON6 == false ]]; then
    echo "Proton 6/Proton - Experimental not found!"
    echo "Make sure you installed Proton 6+ for the game to launch properly."
    exit 1
fi
echo "Patching dowser.exe --> Cities.exe"
mv dowser.exe dowser.exe.bak
ln -sf Cities.exe dowser.exe
ln -sf Cities_Data dowser_Data 
echo "Done! You can now launch the game in Steam."
xdg-open https://www.youtube.com/watch?v=dQw4w9WgXcQ
neofetch
