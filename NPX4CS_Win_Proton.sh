#!/bin/bash

NPL_WIN_DL='https://github.com/shusaura85/notparadoxlauncher/releases/download/v1.3.1/Windows.Not.Paradox.Launcher.v1.3.1.x64.zip'

echo "NotParadoxLauncher for Cities: Skylines (Windows version running in Proton)"
echo "Type your Cities:Skylines location (default is $HOME/.local/share/Steam/steamapps/common/Cities_Skylines/):"
read CS_LOCATION
[ -z "$CS_LOCATION" ] && CS_LOCATION="$HOME/.local/share/Steam/steamapps/common/Cities_Skylines/"
echo "Changing directory to Cities: Skylines..."
cd "$CS_LOCATION"
rm -rf NPX_WIN.zip
rm -rf NotParadoxLauncher
echo "Downloading NotParadoxLauncher (Windows version)..."
wget -O NPX_WIN.zip "$NPL_WIN_DL"
echo "Extracting NotParadoxLauncher..."
mkdir -p ./NotParadoxLauncher
unzip ./NPX_WIN.zip -d NotParadoxLauncher
echo "Detecting installed Proton..."
PROTONS=()
for steam_apps in ./../*/; do
    if [[ $steam_apps == *"Proton"* ]];then
        echo "Found Proton: $steam_apps"
        PROTONS+=("$steam_apps")
    fi
done
echo "Available Proton:"
for idx in ${!PROTONS[@]}; do
    echo "[$idx]: ${PROTONS[idx]}"
done
echo "Select: "
read PROTON_SEL_INT
PROTON_SEL_slash=${PROTONS[PROTON_SEL_INT]}
PROTON_SEL=${PROTON_SEL_slash%?}
echo "Selected $PROTON_SEL, processing..."
echo "Creating NotParadoxLauncher script..."
PREFIXPATH=$(realpath "./../../compatdata/255710/pfx")
echo "WINEPREFIX=\"$PREFIXPATH\" \"$PROTON_SEL/files/bin/wine\" ./NotParadoxLauncher/bootstrapper-v2.exe" > launcher.sh
chmod +x launcher.sh
echo "Done! You can launch NotParadoxLauncher by doing './launcher.sh' in Cities: Skylines dir."
