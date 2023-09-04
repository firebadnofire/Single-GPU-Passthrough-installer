#!/bin/bash

# Check if the script is run with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

# Display menu and get user choice
while true; do
    echo "Choose an option:"
    echo "1. Pop!_OS"
    echo "2. Debian"
    echo "3. Arch"
    echo "4. Fedora"
    echo "5. Exit"

    read -p "Enter your choice (1-5): " choice

    case $choice in
        1)
            chmod +x ./pop2_install.sh
	    ./pop2_install.sh
            exit 0
            ;;
        2)
	    echo "Deb"
            exit 0
            ;;
        3)
            echo "arc"
            exit 0
            ;;
        4)
            echo "Fed"
	    exit 0
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number between 1 and 5."
            ;;
    esac

done
