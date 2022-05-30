# leagueoflinux scripts
## `sulaunchhelper2.sh`
This script is a wrapper for `sulaunchhelper2.py` and `syscall_check.sh`, for use with Lutris pre-game launch script.
### Installation
+ To install you must have `sulaunchhelper2.py` and `syscall_check.sh` present, if not you can execute these to quickly download them (to current directory):
```sh
curl -OL https://gitlab.com/tretrauit/scripts/-/raw/main/games/LoL/linux/sulaunchhelper2.py
curl -OL https://gitlab.com/tretrauit/scripts/-/raw/main/games/LoL/linux/syscall_check.sh
chmod +x sulaunchhelper2.py syscall_check.sh
```
+ Then to download `sulaunchhelper2.sh` itself:
```sh
curl -OL https://gitlab.com/tretrauit/scripts/-/raw/main/games/LoL/linux/sulaunchhelper2.sh
chmod +x sulaunchhelper2.sh
```
+ After that, copy all these files to the game prefix you want to use, then in Lutris:
    - Set pre-launch script in Lutris to where `sulaunchhelper2.sh` is located.
    - Disable **Wait for pre-launch script completion**
    - Enable **Disable Lutris Runtime**
> Failure to do above steps will result in Zenity can't show necessary messages dialog so LoL UI can't launch properly.
+ Enjoy your LoL experience :P
## `garena_wrapper.sh`
This script automates the launching of [lol.py](https://github.com/nhubaotruong/league-of-legends-linux-garena-script) (LoL in Garena client) so you don't have to manually do it ;)
### Installation
Because this script is used in Lutris pre-game launch script, it also wrap `syscall_check.sh`. You also need to follow steps in `lol.py` repository to properly config your LoL prefix.
+ To install you must have `lol.py` and `syscall_check.sh` present, if not you can execute these to quickly download them (to current directory):
```sh
curl -OL https://raw.githubusercontent.com/nhubaotruong/league-of-legends-linux-garena-script/main/lol.py
curl -OL https://gitlab.com/tretrauit/scripts/-/raw/main/games/LoL/linux/syscall_check.sh
chmod +x sulaunchhelper2.py syscall_check.sh
```
+ Then to download `garena_wrapper.sh` itself:
```sh
curl -OL https://gitlab.com/tretrauit/scripts/-/raw/main/games/LoL/linux/garena_wrapper.sh
chmod +x garena_wrapper.sh
```
+ After that, copy all these files to the game prefix you want to use, then in Lutris:
    - Set pre-launch script in Lutris to where `garena_wrapper.sh` is located.
    - Disable **Wait for pre-launch script completion**
    - Enable **Disable Lutris Runtime**
> Failure to do above steps will result in Zenity can't show necessary messages dialog so LoL UI may not launch properly (it'll still launch if you use `sulaunchhelper2.sh` and have installed it correctly).
+ Enjoy your Garena LoL experience :P
