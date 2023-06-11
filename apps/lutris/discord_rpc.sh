#!/bin/bash
# Launch winediscordipcbridge.exe automatically.

echo "wine: $WINE"
echo "prefix: $WINEPREFIX"
$WINE ./winediscordipcbridge.exe
