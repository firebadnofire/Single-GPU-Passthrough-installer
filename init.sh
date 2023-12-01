#!/bin/bash

#Check for current dir
needed="Single-GPU-Passthrough-installer"
wd=$(pwd)

if echo "$wd" | grep -q "$needed"; then
    sleep 0
else
    echo "Please run this script in the Single-GPU-Passthrough-installer directory"
    exit 0
fi


# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

while true; do
    echo "==== What model is your CPU? ===="
    echo "1. AMD"
    echo "2. Intel"
    echo "3. Exit to CLI"
    read -p "Enter your choice (1-3): " choice1

    case $choice1 in
        1)
            echo "AMD" > CPU.txt
            break
            ;;
        2)
            echo "Intel" > CPU.txt
            break
            ;;
        3)
            echo "Exiting to CLI."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option (1-3)."
            ;;
    esac
done
echo ""
while true; do
    echo "==== What model is your GPU? ===="
    echo "1. AMD"
    echo "2. Nvidia"
    echo "3. Exit to CLI"
    read -p "Enter your choice (1-3): " choice1

    case $choice1 in
        1)
            echo "AMD" > GPU.txt
            break
            ;;
        2)
            echo "Nvidia" > GPU.txt
            break
            ;;
        3)
            echo "Exiting to CLI."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option (1-3)."
            ;;
    esac
done
echo ""

while true; do
    echo $GPU
    echo "==== What OS are you using? ===="
    echo "1. Debian"
    echo "2. Arch"
    echo "3. Fedora"
    echo "4. Exit to CLI"
    read -p "Enter your choice (1-5): " choice2

    case $choice2 in
        1)
            echo "deb" > OS.txt
            break
            ;;
        2)
            echo "arch" > OS.txt
            break
            ;;
        3)
            echo "fedora" > OS.txt
            break
            ;;
        4)
            echo "Exiting to CLI."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option (1-5)."
            ;;
    esac
done

OS=$(sed -n -e 1p OS.txt)

if [ "$OS" == "deb" ]; then
        ins-phase1/deb1-install.sh
        echo "Please reboot before running install.sh"
elif [ "$OS" == "arch" ]; then
        ins-phase1/arch1-install.sh
        echo "Please reboot before running install.sh"
elif [ "$OS" == "fedora" ]; then
        ins-phase1/fedora1-install.sh
	echo "Please reboot before running install.sh"
else
    echo "OS.txt does not match any expected values"

fi
