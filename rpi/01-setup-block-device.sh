#!/bin/sh

################################################################################
# Block device set-up script.
#
# Choice of shebang allows for execution by busybox.
# (i.e. run this file with `sudo busybox sh 01-setup-block-device.sh`)
#
# This shell script attempts to comply with:
# https://google.github.io/styleguide/shellguide.html
################################################################################

# Exit script if executed without root privileges

if [ "$(id -u)" -ne 0 ];
  then echo "This script requires root privileges to execute.  Exiting"
  exit
fi

# Set variables

block_device="/dev/nvme0n1"
normal=$(printf '\033[0m')
redbold=$(printf '\033[91;1m')
greenbold=$(printf '\033[92;1m')
cyanbold=$(printf '\033[96;1m')
bluebold=$(printf '\033[94;1m')

# Warning 10 second countdown

echo -e "\n${redbold}WARNING: About to erase ${normal}${block_device}"
echo -ne "10 "
sleep 1
echo -ne "\r 9 "
sleep 1
echo -ne "\r 8 "
sleep 1
echo -ne "\r 7 "
sleep 1
echo -ne "\r 6 "
sleep 1
echo -ne "\r 5 "
sleep 1
echo -ne "\r 4 "
sleep 1
echo -ne "\r 3 "
sleep 1
echo -ne "\r 2 "
sleep 1
echo -ne "\r 1 "
sleep 1
echo -e "\r 0"
sleep 1

# Wipe old partition information from target block device

echo -e "\n${redbold}Running ${normal}sgdisk -Z ${block_device}\n"
sgdisk -Z ${block_device}

# 1G (Gibibyte) "bootfs" FAT32 partition, right at start

echo -e "\n${cyanbold}Create 1 GiB bootfs${normal}"
sgdisk -n 0:0:+1G -A 0:set:0 -c 0:"bootfs" -t 0:ef00 ${block_device}

# 10G (Gibibyte) "swapfs" +129M (Mebibytes) after Bootfs

echo -e "\n${cyanbold}Create 10 GiB swapfs${normal}"
sgdisk -n 0:+129M:+10G -c 0:"swapfs" -t 0:8200 ${block_device}

# "rootfs" starts +129M after Swapfs and leaves -129M before end

echo -e "\n${cyanbold}Create rootfs${normal}"
sgdisk -n 0:+129M:-129M -c 0:"rootfs" -t 0:8300 ${block_device}

# See the GPT partition info written to disk

echo -e "\n${cyanbold}Print partition information${normal}"
sgdisk -p ${block_device}

# Format bootfs as FAT32

echo -e "\n${cyanbold}Format bootfs as FAT32${normal}"
mkdosfs -F 32 -D 0x80 -i abadc0d3 -n BOOTFS -v ${block_device}p1

# Format swapfs

echo -e "\n${cyanbold}Format swapfs${normal}"
mkswap -L swapfs ${block_device}p2

# Format rootfs as ext4

echo -e "\n${cyanbold}Format rootfs${normal}"
mkfs.ext4 -L rootfs -v ${block_device}p3

# Review output of lsblk

echo -e "${cyanbold}Review output of lsblk${normal}"
lsblk -o name,hotplug,size,pttype,partlabel,parttypename,partflags,fstype,fsver,label
