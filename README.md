<p align="center">
  <img alt="Static Badge" src="https://img.shields.io/badge/License:-GPLv3-green">
  <img alt="Static Badge" src="https://img.shields.io/badge/Ready_for_use:-partially-yellow">
  <img alt="GitHub commit activity (branch)" src="https://img.shields.io/github/commit-activity/t/firebadnofire/Single-GPU-Passthrough-installer">
</p>

#Single-GPU-Passthrough-installer:
Simple script that will install https://gitlab.com/risingprismtv/single-gpu-passthrough

This is NOT finished by any degree and I am not responsable for any damage that may or may not occur.

As of now, Debian is ready for use (and I will try to fix any reported issues). I plan on adding support for Arch and Fedora, but don't expect it soon. School is my top priority right now so this is the last thing on my mind.

## Script explinations:

init.sh: First script to run. This will as you some essential questions like your CPU model, GPU model, and OS. This script also configure /etc/default/grub to have the correct boot arguments. This requires a reboot.

iommu.sh: You should run this after running init.sh and rebooting. This will list your IOMMU groups. Check if your GPU is isolated into a single group. You may have a group with your GPU and the audio controller for the GPU. This is OK. No action is needed. If any other device is in the group that your GPU is in, then you are on your own.

install.sh: This script does the majority of the work. It basically goes through the steps of <https://gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis/> automatically.

NOTE: DO NOT delete OS.txt, CPU.txt, or GPU.txt until you have run and completed install.sh. These store the OS, CPU model, and GPU model. Which is essential to installing this.

## Post run:

After running init.sh and install.sh, check out <https://gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis/5)-Configuring-Virtual-Machine-Manager>, <https://gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis/8)-Attaching-the-GPU-to-your-VM>, and <https://gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis/9)-Additional-editing-of-xml-file>

These will show you how to make the VM in virt-manager.
