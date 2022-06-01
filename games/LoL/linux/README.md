# leagueoflinux scripts
## `sulaunchhelper2.sh`
This script is a wrapper for `sulaunchhelper2.py` for use with Lutris pre-game launch script.
### Installation
<<<<<<< HEAD
> This script no longer wrap `syscall_check.sh`, if you need to execute that script alongside this one, I recommend you to take a look at [preloader.sh](./apps/Lutris#preloadersh)
=======
> This script no longer wrap `syscall_check.sh`, if you need to execute that script alongside this one, I recommend you to take a look at [preloader.sh](../../../apps/Lutris#preloadersh)
>>>>>>> 34b0576 (chore: fix preloader.sh url)

+ To install you must have `sulaunchhelper2.py` present, if not you can execute these to quickly download them (to current directory):
```sh
curl -OL https://raw.githubusercontent.com/CakeTheLiar/launchhelper/master/sulaunchhelper2.py
chmod +x sulaunchhelper2.py
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
<<<<<<< HEAD
> This script no longer wrap `syscall_check.sh`, if you need to execute that script alongside this one, I recommend you to take a look at [preloader.sh](./apps/Lutris#preloadersh)
=======
> This script no longer wrap `syscall_check.sh`, if you need to execute that script alongside this one, I recommend you to take a look at [preloader.sh](../../../apps/Lutris#preloadersh)
>>>>>>> 34b0576 (chore: fix preloader.sh url)

You need to follow steps in `lol.py` repository to properly config your LoL prefix.
+ To install you must have `lol.py` present, if not you can execute these to quickly download them (to current directory):
```sh
curl -OL https://raw.githubusercontent.com/nhubaotruong/league-of-legends-linux-garena-script/main/lol.py
chmod +x sulaunchhelper2.py
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
