#!/usr/bin/bash

AUTHOR="tretrauit"
FAKE_APPRUN_SCRIPT='#!/usr/bin/bash
echo "Starting Yuzu..."
"$APPDIR"/usr/bin/yuzu'

echo "pinEApple/Yuzu EA AppImage portable mode launcher by $AUTHOR"
echo "Removing old yuzu folder..."
rm -rf ./squashfs-root
echo "Extracting AppImage..."
./yuzu-x86_64.AppImage --appimage-extract
cd ./squashfs-root/
echo "Patching..."
ln -sf ../user/ ./user
mv ./AppRun-patched ./AppRun-patched.bak
echo "$FAKE_APPRUN_SCRIPT" > ./AppRun-patched
chmod +x ./AppRun-patched
echo "Launching yuzu..."
APPDIR=./ ./AppRun
