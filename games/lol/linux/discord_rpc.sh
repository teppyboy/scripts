#!/bin/bash
# Launch winediscordipcbridge.exe automatically.

# debug wine version and prefix"
echo "wine: $WINE"
echo "prefix: $WINEPREFIX"

echo "Waiting for LeagueClientUx.exe to start..."
until _=$(pidof LeagueClientUx.exe)
do
    sleep 1
done

echo "Launching bridge..."
$WINE ./winediscordipcbridge.exe
echo "Bridge closed."
