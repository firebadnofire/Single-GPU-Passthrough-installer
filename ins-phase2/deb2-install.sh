#!/bin/bash
sudo apt install qemu-system-x86 libvirt-clients libvirt-daemon-system libvirt-daemon-config-network bridge-utils virt-manager ovmf

#Edit /etc/libvirt/libvirtd.conf
sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf
if grep -q "log_filters=" /etc/libvirt/libvirtd.conf; then
	sleep 0
else
	echo "log_filters=\"3:qemu 1:libvirt\"" >> /etc/libvirt/libvirtd.conf
	echo "log_outputs=\"2:file:/var/log/libvirt/libvirtd.log\"" >> /etc/libvirt/libvirtd.conf
fi
usermod -a -G kvm,libvirt $SUDO_USER
systemctl enable --now libvirtd
echo ""
groups $SUDO_USER
echo ""
echo "Verify you are in the libvirtd group and press any key to continue"
read -n 1 -s -r -p "If you are not, press ctrl+c to stop the script "

#Edit /etc/libvirt/qemu.conf
sed -i "s/#user = \"libvirt-qemu\"/user = \"$SUDO_USER\"/" /etc/libvirt/qemu.conf
sed -i "s/#group = \"libvirt-qemu\"/group = \"$SUDO_USER\"/" /etc/libvirt/qemu.conf
sudo systemctl restart libvirtd
sudo virsh net-autostart default

#ROM file configuration
GPU=$(sed -n -e 1p GPU.txt)

if [ -e "/usr/share/vgabios/patched.rom" ]; then
	echo "GPU ROM already placed."

	elif [ "$GPU" == "Nvidia" ]; then
		if [ -e "./GPU-ROM/patched.rom" ]; then
			echo "patched.rom found"
			mkdir /usr/share/vgabios
			cp ./GPU-ROM/patched.rom /usr/share/vgabios/
			chmod -R 644 /usr/share/vgabios/patched.rom
			chown $SUDO_USER:$SUDO_USER /usr/share/vgabios/patched.rom
		else
			echo "patched.rom not found. Please make a patched.rom then place it in GPU-ROM"
		fi
	elif [ "$GPU" == "AMD" ]; then
		#AMD GPUs don't need a ROM file
		sleep 0
	else
    	echo "GPU.txt does not match any expected values"
fi

#Cloning the main repo

su $SUDO_USER -c "git clone https://gitlab.com/risingprismtv/single-gpu-passthrough.git"
cd single-gpu-passthrough
chmod +x install_hooks.sh
./install_hooks.sh

echo ""
echo ""
#Check if it worked
files_to_check=(
    "/etc/systemd/system/libvirt-nosleep@.service"
    "/usr/local/bin/vfio-startup"
    "/usr/local/bin/vfio-teardown"
    "/etc/libvirt/hooks/qemu"
)

# Initialize a variable to keep track of whether any file is missing
missing_file=0

# Loop through the list and check if each item exists
for file in "${files_to_check[@]}"; do
    if [ ! -e "$file" ]; then
	echo -e "\e[31mFile $file does not exist.\e[0m"
        missing_file=1
    fi
done

# Check if any file was missing and exit accordingly
if [ "$missing_file" -eq 1 ]; then
    echo -e "\e[31mOne or more files/directories were missing.\e[0m"
    exit 1
else
    echo "All files/directories exist."
fi


echo ""
echo ""
echo -e "\e[32mCongrats! You have installed https://gitlab.com/risingprismtv/single-gpu-passthrough!\e[0m"
echo -e "\e[32mSee the README.md for additional info on how to make your VMs.\e[0m"
