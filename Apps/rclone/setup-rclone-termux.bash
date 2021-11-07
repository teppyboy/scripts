#!/bin/bash

RCLONE_PATH="./.rclone-files/"
ARCH=$(uname -m)
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

echo "!!! YOU NEED ROOT TO RUN THIS SCRIPT !!!"
echo "This script was made before I discovered that Termux Rclone can work perfectly too if you mount to /mnt/runtime/write/emulated/0/, using this script may lead to unwanted change in your phone."
read -p "Do you want to continue (Y/n)? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi
echo "Installing dependencies..."
pkg install root-repo tsu wget
echo "Setting up Termux shared storage..."
termux-setup-storage
echo "Downloading rclone..."
mkdir -p $RCLONE_PATH
wget -O - $RCLONE_URL | gunzip -c > "$RCLONE_PATH/rclone"
echo "Downloading fusermount..."
wget -O "$RCLONE_PATH/fusermount" $FUSERMOUNT_URL
sudo chmod -R 0755 ./.rclone-files/
echo "Setup completed, you MUST execute ./rclone-shell before using rclone."
