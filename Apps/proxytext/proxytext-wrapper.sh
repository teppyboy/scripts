#!/bin/bash

function check_android () {
    if $(uname -o) -ne "Android"
    then
        return false
    fi
    return true
}

function proot_install_dependencies () {
    apt update -y
    apt install git chromium nodejs npm -y
    npm install -g --silent yarn
}

function proot_install_proxytext () {
    echo "Installing proxytext."
    git clone https://gitlab.com/tretrauit/proxytext.git
    cd proxytext
    yarn install
}

function proot_launch_proxytext () {
    echo "Launching proxytext."
    cd proxytext
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium yarn start
    exit
}

function install_dependencies () {
    echo "Checking dependencies..."
    declare -a dependencies=("proot-distro")
    for i in "${dependencies[@]}"
    do
        if ! [ -x "$(command -v \"$i\")" ]; then
            echo "Installing $i..."
            pkg install $i
        fi
    done
}

function install_dependencies_debian () {
    echo "Installing dependencies in Debian proot..."
    proot-distro login debian --termux-home -- bash ./proxytext-wrapper.sh --proot --install-dependencies
    echo "Done."
}

function install_debian() {
    echo "Installing debian..."
    proot-distro install debian
}

function install_proxytext () {
    proot-distro login debian --termux-home -- bash ./proxytext-wrapper.sh --proot --install
}

function start_proxytext () {
    proot-distro login debian --termux-home -- bash ./proxytext-wrapper.sh --proot --launch
}

if [[ "$1" = "--proot" ]]
then
    if [[ "$2" = "--launch" ]]
    then
        proot_launch_proxytext
    elif [[ "$2" = "--install" ]]
    then
        proot_install_proxytext
    elif [[ "$2" = "--install-dependencies" ]]
    then
        proot_install_dependencies
    fi
    exit 0
fi

if [[ check_android = false ]];
then
    echo "This script only supports Android using Termux."
    exit 1
fi

install_dependencies
install_debian
install_dependencies_debian
[ ! -d "./proxytext" ] && install_proxytext
echo "Installation completed."
start_proxytext
