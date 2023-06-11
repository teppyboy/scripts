#!/usr/bin/env bash

# Put your game process name here (can be full name or short name)
# If it doesn't work for .exe file, try <process name>.e instead
# it may work.
PROCESS=""

echo "Waiting for '$PROCESS' to start..."
until _=$(pidof $PROCESS)
do
    sleep 1
done

echo "Starting picom..."
picom --experimental-backends &
picom_pid=$!
echo "picom PID: $picom_pid"

echo "Waiting for '$PROCESS' to exit..."
while [[ $(pidof $PROCESS) ]]; do
   sleep .5
done
echo "Killing picom..."
kill -15 $picom_pid
echo "Done."
