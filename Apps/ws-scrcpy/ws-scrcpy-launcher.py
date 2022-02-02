#!/usr/bin/python3
# poorly written for quick and dirty use
import subprocess
import os
import time
import threading

def main():
    print("ws-scrcpy launcher for termux (YOU NEED TO HAVE WS-SCRCPY INSTALLED IN ~/ws-scrcpy)")
    print("THIS SCRIPT REQUIRES ROOT AND TSU, THANK YOU :(")
    print("checking for adb port...")
    adb_lsof_output = subprocess.check_output(["sudo", "lsof", "-i", "-P", "-n"]).decode("utf-8")
    adb_port = None
    try:
        for line in adb_lsof_output.split("\n"):
            if "adbd" in line and "(LISTEN)" in line:
                line = ' '.join(line.split())
                print(line.strip())
                adb_port = line.strip().split(" ")[8].split(":")[1]
                break
    except:
        print("error occured while getting adb port.")
        pass
    if adb_port == None:
        adb_port = input("couldn't find adb port please type manually:")

    device_ip = subprocess.check_output(['ifdata', '-pa', 'wlan0']).decode("utf-8").strip()

    print("adb port:", adb_port)
    print("ip:", device_ip)
    print("connecting to device through adb...")
    connect_result = subprocess.call(["adb", "connect", f"{device_ip}:{adb_port}"])
    if connect_result != 0:
        print("connection failed.")
        exit()
    print("changing directory to home")
    os.chdir("/data/data/com.termux/files/home/")
    print("starting ws-scrcpy server...")
    ws_scrcpy = subprocess.Popen(["npm", "start"], cwd="./ws-scrcpy", stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    def print_ws_scrcpy():
        for line in ws_scrcpy.stdout:
            if line.decode("utf-8").strip is None:
                continue
            if "Listening on:" in line.decode("utf-8").strip():
                device_ip = subprocess.check_output(['ifdata', '-pa', 'wlan0']).decode("utf-8").strip()
                print("=========================================")
                print(f"ws-scrcpy STARTED ON {device_ip}:8000")
                print("=========================================")
            print("[ws-scrcpy]:", line.decode("utf-8").strip())
    ws_scrcpy_thread = threading.Thread(target=print_ws_scrcpy)
    ws_scrcpy_thread.daemon = True
    ws_scrcpy_thread.start()
    print("starting scrcpy server on local device...")
    scrcpy = subprocess.Popen("adb shell su -c 'CLASSPATH=/data/data/com.termux/files/home/ws-scrcpy/vendor/Genymobile/scrcpy/scrcpy-server.jar app_process / com.genymobile.scrcpy.Server 1.19-ws2 web ERROR 8886'",
    shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    def print_scrcpy():
        for line in scrcpy.stdout:
            print("[scrcpy patch]:", line.decode("utf-8").strip())
    scrcpy_thread = threading.Thread(target=print_scrcpy)
    scrcpy_thread.daemon = True
    scrcpy_thread.start()
    print("PLEASE WAIT UNTIL WS-SCRCPY FULLY STARTS (ABOUT 5 MINS), IT TAKES A WHILE TO START THE SERVER.")
    try:
        while True:
            time.sleep(5)
            curr_ip = subprocess.check_output(['ifdata', '-pa', 'wlan0']).decode("utf-8").strip()
            if curr_ip != device_ip:
                print("!!!DEVICE IP ADDRESS CHANGED, PLEASE RESTART SERVER MANUALLY!!!")
                print("!!!SCRCPY WILL NOT WORK UNTIL YOU RESTART THE SERVER!!!")
    except: #  lazy
        if ws_scrcpy.poll() == None:
            print("stopping ws-scrcpy server...")
            ws_scrcpy.terminate()
            try:
                # if this returns, the process completed
                ws_scrcpy.wait(timeout=15)
            except subprocess.TimeoutExpired:
                print("ws_scrcpy doesn't exit after 15 seconds, killing process...")
                ws_scrcpy.kill()

        print("stopping scrcpy server...")
        if scrcpy.poll() == None:
            scrcpy.terminate()
            try:
                # if this returns, the process completed
                scrcpy.wait(timeout=15)
            except subprocess.TimeoutExpired:
                print("scrcpy doesn't exit after 15 seconds, killing process...")
                scrcpy.kill()

        # kill old scrcpy-server to ensure we can start a new one after this.
        try:
            lsof_output = subprocess.check_output(["sudo", "lsof", "-i", "-P", "-n"]).decode("utf-8")
            for line in lsof_output.split("\n"):
                if "8886" in line and "(LISTEN)" in line:
                    line = ' '.join(line.split())
                    print(line.strip())
                    pid = line.strip().split(" ")[1]
                    subprocess.call(["sudo", "kill", "-9", pid])
                    break
        except:
            print("failed to stop scrcpy server")
        print("stopped.")

if __name__ == '__main__':
    main()
