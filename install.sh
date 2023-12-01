#!/bin/bash

needed="Single-GPU-Passthrough-installer"
wd=$(pwd)

if echo "$wd" | grep -q "$needed"; then
    sleep 0
else
    echo "Please run this script in the Single-GPU-Passthrough-installer directory"
    exit 0
fi


if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

OS=$(sed -n -e 1p OS.txt)

if [ "$OS" == "deb" ]; then
	ins-phase2/deb2-install.sh

elif [ "$OS" == "arch" ]; then
	ins-phase2/arch2-install.sh

elif [ "$OS" == "fedora" ]; then
	ins-phase2/fedora2-install.sh

else
    echo "OS.txt does not match any expected values"

fi
