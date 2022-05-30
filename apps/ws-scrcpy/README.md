# ws-scrcpy scripts

## ws-scrcpy-launcher.py for Termux

### Notes

+ **YOU NEED TO HAVE WS-SCRCPY INSTALLED, ALONG WITH ROOT ACCESS AND DEPENDENCIES**
+ ~~YOU ALSO NEED TO OPEN ADB WIRELESS IN DEVELOPER SETTINGS FOR THIS TO WORK~~ (The script can use `su` to start ADB wireless now)
+ You need to grant Termux:API full Location permission and set to "Always" (Foreground mode will not work correctly)
+ Rootless mode is available, although it **will not** work in most cases.
+ Dependencies: `root-repo` `tsu` `moreutils` `build-essential` `nodejs` `python3` `android-tools` `git` `termux-api`

> Or execute `pkg install root-repo tsu moreutils build-essential nodejs python3 android-tools git termux-api`

+ You also need to downgrade npm to version 6 to fix Termux problem: `npm install -g npm@6`

> Please ignore the vulnerability message, if you care about it then please don't use this script.

+ Download ws-scrcpy-launcher.py:

```bash
curl -OL https://gitlab.com/tretrauit/scripts/-/raw/main/Apps/ws-scrcpy/ws-scrcpy-launcher.py
chmod +x ws-scrcpy-launcher.py
```

> Execute `./ws-scrcpy-launcher.py` to launch ws-scrcpy with scrcpy server for local device.

+ Full script for lazy people (including install ws-scrcpy steps):

```bash
pkg update
pkg install root-repo moreutils build-essential nodejs python3 android-tools git
pkg install tsu
npm install -g npm@6
cd ~
git clone https://github.com/NetrisTV/ws-scrcpy
cd ./ws-scrcpy
npm install
curl -OL https://gitlab.com/tretrauit/scripts/-/raw/main/Apps/ws-scrcpy/ws-scrcpy-launcher.py
chmod +x ws-scrcpy-launcher.py
```

+ The script will tell you to wait for ws-scrcpy to start, and when it starts it'll show the started message with the ip address and the port to access using browsers

> You need to use `adb pair` to pair termux with your device adb server, then you can launch ws-scrcpy as explained above.
