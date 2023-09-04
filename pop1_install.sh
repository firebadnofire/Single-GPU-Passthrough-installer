#!/bin/bash
replace="/boot/efi/loader/entries/Pop_OS-current.conf"
# Check if the input file exists
if [ ! -f "$replace" ]; then
  echo "err: no file found: /boot/efi/loader/entries/Pop_OS-current.conf"
  exit 1
fi

# Define the string to search for and the replacement string
search_string="systemd.show_status=false"
replacement_string="systemd.show_status=false amd_iommu=on iommu=pt"

# Use sed to replace the string in the file
sed -i "s/$search_string/$replacement_string/g" "$replace"

echo "Edited: $replace"

