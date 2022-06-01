# Lutris scripts
## `preloader.sh`
Execute multiple scripts in a folder (default is `./preloader`), usually useful for Lutris Pre-launch/Post-exit script
+ This script will execute scripts in **current directory** *(where `preloader.sh` is executed)*, so for example if a script need a file called `nightmare`, and preloader.sh is in `~`, **put it in `~`** instead of `~/preloader/nightmare`
### Installation
+ To download `preloader.sh` itself:
```sh
curl -OL https://gitlab.com/tretrauit/scripts/-/raw/main/apps/Lutris/preloader.sh
chmod +x preloader.sh
```
+ After that, copy/move this script to the game prefix you want to use, then in Lutris:
    - Set pre-launch script in Lutris to where `preloader.sh` is located.
    - Disable **Wait for pre-launch script completion**
    - *(Optional)* Enable **Disable Lutris Runtime**

+ Enjoy :L
