#!/bin/bash
# This script is a wrapper for nhubaotruong/league-of-legends-linux-garena-script and syscall_check.sh
# It automatically execute lol.py to start LoL lutris game from Garena.
# You need lol.py and syscall_check.sh present in game prefix root directory.

SCC_SH='syscall_check.sh'
LOL_PY='lol.py'

dialog() {
    zenity "$@" --icon-name='lutris' --width="400" --title="Garena LoL to LoL lutris wrapper"
}

own_dir="$(realpath .)"
# try to call syscall_check.sh
if ! [ -x "${own_dir}/${SCC_SH}" ]; then
    dialog "Please place this script into the same directory as '${SCC_SH}'!"
else
    sh "${own_dir}/${SCC_SH}"
fi

echo "Waiting for Garena to start..."
until _=$(pidof Garena.exe)
do
    sleep 1
done

trap final EXIT

echo "Entering loop..."
noGarena=0
lolPyPid=""

final() {
    echo "Exiting..."
    if [[ -z $(kill -0 $lolPyPid) ]]; then
        echo "Closing lol.py..."
        kill -15 $lolPyPid
    fi
}

trap final EXIT

while :
do
    if [[ -z $(pidof Garena.exe) ]]; then
        exit
    fi
    noGarena=0
    if [[ $lolPyPid ]]; then
        kill -0 $lolPyPid
        if [[ $? -ne 0 ]]; then
            echo "Clearing old exited lol.py PID."
            lolPyPid=""
        fi
    fi
    if [[ -z $(pidof RiotClientServices.exe) ]] && [[ -z $lolPyPid ]]; then
        echo "Launching lol.py"
        python3 "${own_dir}/${LOL_PY}" &
        lolPyPid=$!
    fi
    sleep .5
done
exit

