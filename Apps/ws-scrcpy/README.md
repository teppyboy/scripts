# ws-scrcpy scripts
## ws-scrcpy-launcher.py for Termux
### YOU NEED TO HAVE WS-SCRCPY INSTALLED, ALONG WITH ROOT ACCESS AND DEPENDENCIES
+ **YOU ALSO NEED TO OPEN ADB WIRELESS IN DEVELOPER SETTINGS FOR THIS TO WORK**
+ root maybe not needed but **i haven't tested it yet** so do it with your own risk (the script won't fail even if it can't have root access btw)
+ dependencies: `root-repo` `tsu` `moreutils` `build-essential` `nodejs` `python3` `android-tools` `git`
+ you also need to downgrade npm to version 6 to fix npm on termux: `npm install -g npm@6`
> ignore the vulnerability please if you care about it please don't use this script
+ download ws-scrcpy-launcher.py:
```bash
curl -OL https://gitlab.com/tretrauit/scripts/-/raw/main/Apps/ws-scrcpy/ws-scrcpy-launcher.py
chmod +x ws-scrcpy-launcher.py
```
> after this use `./ws-scrcpy-launcher.py` to launch ws-scrcpy with scrcpy server for local device.
+ full script for lazy people (including install ws-scrcpy):
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
> after this you need to use `adb pair` to pair termux with your device adb server, then you can launch ws-scrcpy as explained above.
#### After this, the script will tell you to wait for ws-scrcpy to start, and when it starts it'll show the started message with the ip address and the port to access using browsers
