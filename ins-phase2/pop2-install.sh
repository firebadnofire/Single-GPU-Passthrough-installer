#!/bin/bash
GPU=$(sed -n -e 1p GPU.txt)
apt install qemu-system-x86 libvirt-clients libvirt-daemon-system libvirt-daemon-config-network bridge-utils virt-manager ovmf

wai=$SUDO_USER

rom="./GPU-ROM/patched.rom"
#Check GPU
if [[ $GPU == "Nvidia" ]]; then
    echo "Nvidia GPU detected'"
    # Check if the file exists
    if [ -f "$rom" ]; then
        sudo mkdir -p /usr/share/vgabios
        cp $rom /usr/share/vgabios/
        cd /usr/share/vgabios
        sudo chmod -R 644 patched.rom
        sudo chown $wai:$wai patched.rom
    else
        echo "NO ROM PRESENT"
        exit 0
    fi
else
    echo "Non-Nvidia GPU detected"
fi

libvconf="/etc/libvirt/libvirtd.conf"
echo "Editing $libvconf"
if [ -f "$libvconf" ]; then
    # Use sed to search and uncomment the line
    sed -i "s/#unix_sock_group/unix_sock_group/g" "$libvconf"
    sed -i "s/#unix_sock_rw_perms/unix_sock_rw_perms/g" "$libvconf"
    echo 'log_filters="3:qemu 1:libvirt"' >> $libvconf
    echo 'log_outputs="2:file:/var/log/libvirt/libvirtd.log"' >> $libvconf
    sudo usermod -a -G kvm,libvirt $wai
    sudo systemctl enable libvirtd --now
    echo "Done editing"
else
    echo "File not found: $libvconf"
    echo 0
fi

qemuconf="/etc/libvirt/qemu.conf"
echo "Editing $qemuconf"
if [ -f "$qemuconf" ]; then
    # Use sed to search and uncomment the line
    echo "$wai"
    sed -i "s/#user/user/g" "$qemuconf"
    sed -i "s/#group/group/g" "$qemuconf"
    sed -i "s/"root"/$wai/g" "$qemuconf"
    sudo chmod 666 /var/run/libvirt/libvirt-sock
    sudo systemctl restart libvirtd
    sudo virsh net-autostart default
    echo "Done editing"
else
    echo "File not found: $qemuconf"
    exit 0
fi

cd ~
git clone https://gitlab.com/risingprismtv/single-gpu-passthrough.git
pwd
cd single-gpu-passthrough
pwd
chmod +x install_hooks.sh
./install_hooks.sh
cd ..
rm -rf single-gpu-passthrough

file1="/etc/systemd/system/libvirt-nosleep@.service"
file2="/bin/vfio-startup.sh"
file3="/bin/vfio-teardown.sh"
file4="/etc/libvirt/hooks/qemu"

# Check if all four files exist
if [ -f "$file1" ] && [ -f "$file2" ] && [ -f "$file3" ] && [ -f "$file4" ]; then
    echo "All four files exist. Doing nothing."
else
    echo "One or more files do not exist. Stopping."
    exit 1  # Exit the script with an error code
fi
