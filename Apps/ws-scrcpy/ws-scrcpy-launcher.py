#!/usr/bin/python3
# Rewrite
import subprocess
import json
import time
import threading
import random
from pathlib import Path
from shutil import which

APP_UUID="a6db95c2-27db-4b88-a687-c8107d1bc9d6"

def Popen(args: list | str, root=False, shell=False, cwd=Path.cwd()):
    if root:
        if shell:
            args = "sudo " + args
        else:
            args = ["sudo"] + args
    result = subprocess.Popen(args, shell=shell, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return result

def run(args: list | str, root=False, shell=False, cwd=Path.cwd()):
    if root:
        if shell:
            args = "sudo " + args
        else:
            args = ["sudo"] + args
    result = subprocess.run(args, shell=shell, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    result.check_returncode()
    return result

def show_toast(message):
    run(["termux-toast", f'{message}'])

def show_notification(title, message=None, vibration: list[int] | str=None, sound=False, ongoing=True):
    if not which("termux-notification"):
        raise FileNotFoundError("termux-notification not found, please install termux-api package and Termux:API app.")
    args = ["termux-notification", "-i", APP_UUID, "--priority", "max", "-t", f'{title}']
    if message:
        args += ["-c", f'{message}']
    if vibration:
        args += ["--vibrate", ",".join(str(x) for x in vibration) if isinstance(vibration, list) else vibration]
    if sound:
        args += ["--sound"]
    if ongoing:
        args += ["--ongoing"]
    run(args)

def get_wifi():
    if not which("termux-wifi-connectioninfo"):
        raise FileNotFoundError("termux-wifi-connectioninfo not found, please install termux-api package and Termux:API app.")
    return json.loads(subprocess.check_output(["termux-wifi-connectioninfo"]).decode("utf-8"))

def get_wifi_name():
    return get_wifi()["ssid"]

def get_device_private_ip():
    return subprocess.check_output(['ifdata', '-pa', 'wlan0']).decode("utf-8").strip()

def get_port_from_process_name(name: str, state: str="LISTEN"):
    lsof_output = subprocess.check_output(["sudo", "lsof", "-i", "-P", "-n"]).decode("utf-8")
    for line in lsof_output.split("\n"):
        if name in line and f"({state})" in line:
            line = ' '.join(line.split())
            return int(line.strip().split(" ")[8].split(":")[1])
    return None

def get_pid_from_port(port: int, state: str="LISTEN"):
    lsof_output = subprocess.check_output(["sudo", "lsof", "-i", "-P", "-n"]).decode("utf-8")
    for line in lsof_output.split("\n"):
        if str(port) in line and f"({state})" in line:
            line = ' '.join(line.split())
            return line.strip().split(" ")[1]
    return None

def start_adbd():
    free_port = random.randint(0, 65535)
    while get_pid_from_port(free_port):
        free_port = random.randint(0, 65535)
    print("Starting adbd on port " + str(free_port))
    show_notification("Starting adbd", "Starting adbd on port " + str(free_port))
    try:
        run(["setprop", "service.adb.tcp.port", str(free_port)], root=True)
    except subprocess.CalledProcessError:
        print("Failed to set adb port")
        show_notification("Failed to set adb port to " + str(free_port), "You'll need to start adb manually through Developer Settings")
        return
    try:
        run(["stop", "adbd"], root=True)
    except subprocess.CalledProcessError:
        print("Failed to stop adbd, maybe adbd was not running?")
    try:
        run(["start", "adbd"], root=True)
    except subprocess.CalledProcessError:
        print("Failed to start adbd")
        show_notification("Failed to start adbd", "You'll need to start adb manually through Developer Settings")
        return
    return free_port

def connect_adb(ip, port):
    run(["adb", "connect", f"{ip}:{port}"])

def main():
    print("ws-scrcpy launcher for Termux")
    print("Checking for ws-scrcpy...")
    if not Path("./ws-scrcpy").exists():
        print("ws-scrcpy not found, please install ws-scrcpy.")
        return
    print("Checking for current adb port...")
    show_notification("Checking for current adb port...")
    adb_port = None
    try:
        adb_port = get_port_from_process_name("adbd")
    except:
        pass
    if adb_port is None:
        print("Failed to get adb port, starting new adbd...")
        adb_port = start_adbd()
        if adb_port is None:
            print("Failed to start adbd...")
            return

    device_ip = get_device_private_ip()
    wifi_ssid = get_wifi_name()

    print("Adb server port:", adb_port)
    print("Device IP:", device_ip)
    print("Connecting to device through adb...")
    show_notification("Connecting to device through adb...")
    try:
        connect_adb(device_ip, adb_port)
    except subprocess.CalledProcessError:
        print("Failed to connect to device through adb")
        show_notification("Failed to connect to device through adb", "You'll need to connect manually in Termux.")
        return

    print("Starting ws-scrcpy server...")
    show_notification("Starting ws-scrcpy server...", "You may need to wait for 5 minutes for ws-scrcpy to start.")
    ws_scrcpy = Popen(["npm", "start"], cwd="./ws-scrcpy")
    def print_ws_scrcpy():
        for line in ws_scrcpy.stdout:
            if line.decode("utf-8").strip() == None:
                continue
            if "Listening on:" in line.decode("utf-8").strip():
                device_ip = get_device_private_ip()
                wifi_ssid = get_wifi_name()
                print("=========================================")
                print(f"ws-scrcpy started on {device_ip}:8000 on {wifi_ssid}")
                print("=========================================")
                show_toast(f"ws-scrcpy: {device_ip}:8000 on {wifi_ssid}")
                show_notification(f"ws-scrcpy: {device_ip}:8000", f"Wifi: {wifi_ssid}, access {device_ip}:8000 in browser to control the device.", [2000, 1000, 500], True)
            print("[ws-scrcpy]:", line.decode("utf-8").strip())
    ws_scrcpy_thread = threading.Thread(target=print_ws_scrcpy)
    ws_scrcpy_thread.daemon = True
    ws_scrcpy_thread.start()

    print("PLEASE WAIT UNTIL WS-SCRCPY FULLY STARTS (ABOUT 5 MINS), IT TAKES A WHILE TO START THE SERVER.")
    try:
        while True:
            time.sleep(2.5)
            curr_ip = get_device_private_ip()
            # print("ip:", curr_ip)
            curr_ssid = get_wifi_name()
            # print("ssid:", curr_ssid)
            if curr_ip != device_ip:
                print("Device IP changed, reconnecting adb...")
                show_notification("Reconnecting adb...", "This may take a while, take a cup of coffee.")
                try:
                    connect_adb(curr_ip, adb_port)
                except subprocess.CalledProcessError:
                    print("Failed to connect to device through adb")
                    show_notification("Failed to connect to device through adb", "ws-scrcpy will be stopped.")
                    break
                device_ip = curr_ip
                print("=========================================")
                print(f"ws-scrcpy IP changed to {device_ip}:8000 on {wifi_ssid}")
                print("=========================================")
                show_toast(f"ws-scrcpy: {device_ip}:8000 on {wifi_ssid}")
                show_notification(f"ws-scrcpy: {device_ip}:8000", f"Wifi: {wifi_ssid}, access {device_ip}:8000 in browser to control the device.", [2000, 1000, 500], True)
            if curr_ssid != wifi_ssid and curr_ssid not in "<unknown ssid>":  # Do not set current ssid to unknown ssid.
                print("Wifi ssid changed, changing ssid in notification...")
                wifi_ssid = curr_ssid
                print("=========================================")
                print(f"ws-scrcpy IP changed to {device_ip}:8000 on {wifi_ssid}")
                print("=========================================")
                show_toast(f"ws-scrcpy: {device_ip}:8000 on {wifi_ssid}")
                show_notification(f"ws-scrcpy: {device_ip}:8000", f"Wifi: {wifi_ssid}, access {device_ip}:8000 in browser to control the device.")
    except:
        pass

    if ws_scrcpy.poll() == None:
        print("Stopping ws-scrcpy server...")
        show_notification("Stopping ws-scrcpy server...")
        ws_scrcpy.terminate()
        try:
            # if this returns, the process completed
            ws_scrcpy.wait(timeout=15)
        except subprocess.TimeoutExpired:
            print("ws_scrcpy doesn't exit after 15 seconds, killing process...")
            ws_scrcpy.kill()

    print("ws-scrcpy has been stopped.")
    show_notification("ws-scrcpy has been stopped.", ongoing=False)

if __name__ == '__main__':
    main()
