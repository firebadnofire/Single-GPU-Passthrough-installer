#!/bin/bash
#Define vars
GPU=$(sed -n -e 1p GPU.txt)
replace="/boot/efi/loader/entries/Pop_OS-current.conf"
search_string="systemd.show_status=false"

#Check for file in case a future update breaks this
if [ ! -f "$replace" ]; then
  echo "err: no file found: /boot/efi/loader/entries/Pop_OS-current.conf"
  exit 1
fi

if grep -q "iommu=pt" "$replace"; then
    echo "Change already ran. Doing nothing."
    exit 0
else
    echo "continue"
fi

if [ "$GPU" == "AMD" ]; then
	#AMD specific replace
	replacement_string="systemd.show_status=false video=efifb:off amd_iommu=on iommu=pt"
	sed -i "s/$search_string/$replacement_string/g" "$replace"
	echo "Edited: $replace using $GPU specific changes"
	sudo bootctl update
else
	replacement_string="systemd.show_status=false amd_iommu=on iommu=pt"
	sed -i "s/$search_string/$replacement_string/g" "$replace"
	echo "Edited: $replace using $GPU specific changes"
	sudo bootctl update
fi
