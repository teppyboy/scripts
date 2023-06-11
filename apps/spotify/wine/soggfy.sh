#!/usr/bin/bash

if (( $EUID == 0 )); then
    echo "Do not run this script as root."
    exit
fi

[[ -z "${WINEPREFIX}" ]]; WINEPREFIX="$HOME/.wine"
[[ -z "${WINE}" ]]; WINE="wine"

pfx_arch=$(grep '#arch' "$WINEPREFIX/system.reg" | cut -d "=" -f2)
echo "Wine binary: $WINE"
echo "Detected wineprefix: $WINEPREFIX ($pfx_arch)"

download_ffmpeg() {
    if [[ pfx_arch == "win64" ]]; then
        repo_url="https://api.github.com/repos/BtbN/FFmpeg-Builds/releases/latest"
    else
        repo_url="https://api.github.com/repos/sudo-nautilus/FFmpeg-Builds-Win32/releases/latest"
    fi
    asset_info=$(curl -s "$repo_url" | jq '.assets | first(.[] | select(.name | match("ffmpeg")))')
    asset_name=$(echo $asset_info | jq -r '.name')
    echo "Downloading $asset_name..."
    curl -OL "$(echo $asset_info | jq -r '.browser_download_url')"
    echo "Extracting.."
    unzip -j $asset_name "${asset_name%.*}/bin/*" -d "./ffmpeg/"
    rm $asset_name
}

download_soggfy() {
    repo_url="https://api.github.com/repos/Rafiuth/Soggfy/releases/latest"
    asset_info=$(curl -s "$repo_url" | jq '.assets[0]')
    asset_name=$(echo $asset_info | jq -r '.name')
    echo "Downloading $asset_name..."
    curl -OL "$(echo $asset_info | jq -r '.browser_download_url')"
    echo "Extracting.."
    unzip -j $asset_name "${asset_name%.*}/*" -d "."
    rm $asset_name
}

if [ ! -f ./Soggfy.js ]; then
    echo "Soggfy not found, downloading..."
    download_soggfy
fi

if [ ! -d "./ffmpeg/" ]; then
    echo "FFmpeg not found, downloading..."
    mkdir ./ffmpeg/
    download_ffmpeg
fi

echo "Waiting for Spotify to start..."
until _=$(pidof Spotify.exe)
do
    sleep 1
done

echo "Injecting..."
WINEPREFIX=$WINEPREFIX $WINE Injector.exe
echo "Done."
