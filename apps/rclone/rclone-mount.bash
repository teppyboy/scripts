#!/usr/bin/bash
RCLONE_REMOTE="<remote name>"
# Rclone remote will be mounted to /mnt/runtime/write/emulated/0/ which is equal to /sdcard in File Explorer (aka your home directory) and equal to ~/storage/shared in Termux
ROOT_HOME_DIR="/mnt/runtime/write/emulated/0/"
RCLONE_MOUNT_DIR="<mount directory>"

FINAL_DIR="$ROOT_HOME_DIR$RCLONE_MOUNT_DIR"
if [ "$1" = "unmount" ]; then
    sudo pkill -f "rclone --vfs-cache-mode writes -v mount \"$RCLONE_REMOTE\": \"$FINAL_DIR\" --gid 9997 --dir-perms 0771 --file-perms 0660 --umask=0 --allow-other"
    sudo fusermount -u "$FINAL_DIR"
    echo "$RCLONE_REMOTE should be unmounted now, if fusermount raises Invalid option then that's OK."
else
    sudo mkdir -p "$FINAL_DIR"
    sudo nohup rclone --vfs-cache-mode writes -v mount "$RCLONE_REMOTE": "$FINAL_DIR" --gid 9997 --dir-perms 0771 --file-perms 0660 --umask=0 --allow-other &
    echo "$RCLONE_REMOTE should be mounted now, check $RCLONE_MOUNT_DIR"
fi
