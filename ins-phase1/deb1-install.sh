#!/bin/bash
#Define vars
GPU=$(sed -n -e 1p GPU.txt)
CPU=$(sed -n -e 1p CPU.txt)
sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"$CPU_iommu=on video=efifb:off iommu=pt\"/" /etc/default/grub

if command -v update-grub &> /dev/null; then
  sudo update-grub
else
    # Check if "/boot/grub" directory exists
    if [ -d "/boot/grub" ]; then
        grub-mkconfig -o /boot/grub/grub.cfg
    elif [ -d "/boot/grub2" ]; then
        grub2-mkconfig -o /boot/grub2/grub.cfg
    else
        echo "Neither update-grub nor /boot/grub or /boot/grub2 directory found."
	echo "This script may be majorly outdated."
	echo "DO NOT RUN install.sh"
    fi
fi
