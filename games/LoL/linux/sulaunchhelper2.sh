#!/bin/bash
# This script is a wrapper for sulaunchhelper2.py and somewhat based on syscall_check.sh for kernel.yama.ptrace_scope wrapper
# Because this is for Lutris pre-launch script, you're required to have both sulaunchhelper2.py and syscall_check.sh
# present in the game' wineprefix

SULH_PY='sulaunchhelper2.py'

dialog() {
    zenity "$@" --icon-name='lutris' --width="400" --title="League of Legends launch helper (root version)"
}

own_dir="$(realpath .)"

echo "Trying to check for Frida kernel argument..."
if [ "$(cat /proc/sys/kernel/yama/ptrace_scope)" -ne 0 ]; then
    once="Change setting until next reboot"
    persist="Change setting and persist after reboot"
    manual="Show me the commands; I'll handle it myself"

    if dialog --question --text="League of Legends' client UI launch much faster with some modification to your system. but as far as this script can detect, the setting has not been changed yet.\n\nWould you like to change the setting now?"
    then
        # I tried to embed the command in the dialog and run the output, but
        # parsing variables with embedded quotes is an excercise in frustration.
        RESULT=$(dialog --list --radiolist --height="200" \
            --column="" --column="Command" \
            "TRUE" "$once" \
            "FALSE" "$persist" \
            "FALSE" "$manual")

        case "$RESULT" in
            "$once")
                pkexec sysctl -w kernel.yama.ptrace_scope=0
                ;;
            "$persist")
                pkexec sh -c 'echo "kernel.yama.ptrace_scope=0" >> /etc/sysctl.conf && sysctl -p'
                ;;
            "$manual")
                dialog --info --no-wrap --text="To change the setting (a kernel parameter) until next boot, run:\n\nsudo sh -c 'sysctl -w kernel.yama.ptrace_scope=0'\n\nTo persist the setting between reboots, run:\n\nsudo sh -c 'echo \"kernel.yama.ptrace_scope=0\" >> /etc/sysctl.conf &amp;&amp; sysctl -p'\nChange the setting then press OK or script will NOT work."
                ;;
            *)
                echo "Dialog canceled or unknown option selected: $RESULT"
                ;;
        esac
    fi
fi

python3 "${own_dir}/${SULH_PY}"
