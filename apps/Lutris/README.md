# Lutris scripts
## `preloader.sh`
Execute multiple scripts in a folder (default is `./preloader`), usually useful for Lutris Pre-launch/Post-exit script
+ Logging is enabled by default, but can be disabled by changing DEBUG to 0 in script source (`DEBUG=0`)
> This script will execute scripts in **current directory** *(where `preloader.sh` is executed)*, so for example if a script need a file called `nightmare`, and preloader.sh is in `~`, **put it in `~`** *instead of `~/preloader/nightmare`*
### Installation
+ To download `preloader.sh` itself:
```sh
curl -OL https://gitlab.com/tretrauit/scripts/-/raw/main/apps/Lutris/preloader.sh
chmod +x preloader.sh
```
+ After that, copy/move this script to the game prefix you want to use, then in Lutris:
    - Set pre-launch script in Lutris to where `preloader.sh` is located.
    - Disable **Wait for pre-launch script completion**

+ **IMPORTANT**: Now, to add pre-launch script, instead of setting them in Lutris, add them to `./preloader` (or the folder you specified).
+ Enjoy :L

## `discord_rpc.sh`
Launch winediscordrpcbridge.exe, to be able to get Discord Rich Presence on Wine applications on the specified prefix.

### Installation
+ To download `discord_rpc.sh` itself:
```sh
curl -OL https://gitlab.com/tretrauit/scripts/-/raw/main/apps/Lutris/discord_rpc.sh
chmod +x discord_rpc.sh
```
+ After that, copy/move this script to the game prefix you want to use, then in Lutris:
    - Set pre-launch script in Lutris to where `discord_rpc.sh` is located.
    - Disable **Wait for pre-launch script completion**

+ Enjoy :L
