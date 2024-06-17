#!/bin/sh

################################################################################
# Block device set-up script.
#
# Choice of shebang allows for execution by busybox.
# (i.e. run this file with `busybox sh script-updater.sh`)
#
# This shell script attempts to comply with:
# https://google.github.io/styleguide/shellguide.html
################################################################################

# Exit script if executed without root privileges

if [ "$(id -u)" -ne 0 ];
  then echo "This script requires root privileges to execute.  Exiting"
  exit
  else

# Set variables

block_device="/dev/nvme0n1"
normal=$(printf '\033[0m')
redbold=$(printf '\033[91;1m')
greenbold=$(printf '\033[92;1m')
cyanbold=$(printf '\033[96;1m')
bluebold=$(printf '\033[94;1m')

# Warning 10 second countdown

echo -e "\n${redbold}WARNING: About to erase ${normal}${block_device}"
echo -ne "10"
sleep 1
echo -ne "\033[2K 9"
sleep 1
echo -ne "\033[2K 8"
sleep 1
echo -ne "\033[2K 7"
sleep 1
echo -ne "\033[2K 6"
sleep 1
echo -ne "\033[2K 5"
sleep 1
echo -ne "\033[2K 4"
sleep 1
echo -ne "\033[2K 3"
sleep 1
echo -ne "\033[2K 2"
sleep 1
echo -ne "\033[2K 1"
sleep 1
echo -e "\033[2K 0"

# Partitioning scheme for block device:
# (1) 1G (Gibibyte) "Bootfs" right at start (FAT32).
# (2) 10G (Gibibyte) "Swapfs" +129M (Mebibytes) after Bootfs.
# (3) "Rootfs" +129M after Swapfs and ending -129M from end of device.

# 

# Close the root privileges if-then

fi
