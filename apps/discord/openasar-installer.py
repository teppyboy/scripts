#!/usr/bin/env python3

from pathlib import Path
from urllib import request
from shutil import which

def find_discord_asar(discord_exec: str) -> Path | None:
    dis_loc = which(discord_exec)
    if not dis_loc:
        return
    dis = Path(dis_loc)
    with dis.open("r") as f:
        try:
            content = f.read(256)
        except UnicodeDecodeError:
            # Official Discord app, the binary is hopefully symlink
            # e.g. /usr/bin/discord -> /opt/discord/Discord
            asar_path = dis.resolve().parent.joinpath("resources/app.asar")
            if asar_path.is_file():
                return asar_path
        else:
            # Discord wrapper script (Discord system Electron, etc.)
            for v in content.split():
                if "app.asar" not in v:
                    continue
                # v is full path to app.asar
                # e.g. /usr/lib/discord-canary/app.asar
                return Path(v)


def download_openasar():
    file, _ = request.urlretrieve("")
    return file

def main():
    print(find_discord_asar("discord-canary"))
    # print("Downloading OpenAsar (nightly)...")
    # file = request.urlretrieve("")

if __name__ == "__main__":
    main()