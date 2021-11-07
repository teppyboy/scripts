#!/bin/bash

RCLONE_PATH="./.rclone-files/"

ARCH=$(uname -m)

echo "!!! YOU NEED ROOT TO RUN THIS SCRIPT !!!"
echo "Installing dependencies..."
pkg install root-repo tsu wget
echo "Setting up Termux shared storage..."
termux-setup-storage
echo "Downloading rclone..."
mkdir -p $RCLONE_PATH
RCLONE_URL=""
FUSERMOUNT_URL=""
if [ "$ARCH" == "armv7l" ];then
    RCLONE_URL="https://beta.rclone.org/test/testbuilds-latest/rclone-android-16-armv7a.gz"
    FUSERMOUNT_URL="https://github.com/Magisk-Modules-Repo/com.piyushgarg.rclone/raw/master/binary/fusermount-arm"
elif [ "$ARCH" == "aarch64" ];then
    RCLONE_URL="https://beta.rclone.org/test/testbuilds-latest/rclone-android-21-armv8a.gz"
    FUSERMOUNT_URL="https://github.com/Magisk-Modules-Repo/com.piyushgarg.rclone/raw/master/binary/fusermount-arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi
echo "Downloading rclone..."
wget -O - $RCLONE_URL | gunzip -c > "$RCLONE_PATH/rclone"
echo "Downloading fusermount..."
wget -O "$RCLONE_PATH/fusermount" $FUSERMOUNT_URL
sudo chmod -R 0755 ./.rclone-files/
echo "Setup completed, you MUST execute ./rclone-shell before using rclone."
