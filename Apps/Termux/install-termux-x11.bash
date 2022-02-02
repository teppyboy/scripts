#!/bin/bash

echo "Installing dependencies..."
pkg install aria2 termux-x11
termux-setup-storage
mkdir -p ./tmp/
echo "Downloading Termux-x11..."
aria2c -d ./tmp/ https://nightly.link/termux/termux-x11/workflows/debug_build/master/termux-x11.zip
unzip ./tmp/termux-x11.zip -d ./tmp/
rm termux-x11.zip
echo "Installing..."
apt install ./tmp/termux-x11.deb
mv ./tmp/app-debug.apk ~/storage/shared/Downloads/
echo "NOW PLEASE GO TO YOUR DOWNLOAD FOLDER AND INSTALL TERMUX-X11 MANUALLY."
