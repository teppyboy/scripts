# leagueoflinux scripts
## `sulaunchhelper2.sh`
This script is a wrapper for `sulaunchhelper2.py` and `syscall_check.sh`, for use with Lutris pre-game launch script.
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
+ After that, copy all these files to the game prefix you want to use, then set pre-launch script in Lutris to where `sulaunchhelper2.sh` is located.
+ Enjoy your LoL experience :P
