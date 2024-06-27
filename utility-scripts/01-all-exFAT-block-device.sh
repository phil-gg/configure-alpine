#!/bin/sh

################################################################################
# Block device set-up script.
#
# Choice of shebang allows for execution by busybox.
# (i.e. run this file with `sudo busybox sh 01-all-exFAT-block-device.sh`)
#
# This shell script attempts to comply with:
# https://google.github.io/styleguide/shellguide.html
################################################################################

# Exit script if executed without root privileges

if [ "$(id -u)" -ne 0 ];
  then
    printf "%b\n" "This script requires root privileges to execute.  Exiting"
    exit
fi

# Set variables

block_device="/dev/sda"
# shellcheck disable=SC2034  # Okay if this variable is unused
normal='\033[0m'
# shellcheck disable=SC2034  # Okay if this variable is unused
bold='\033[1m'
# shellcheck disable=SC2034  # Okay if this variable is unused
redbold='\033[91;1m'
# shellcheck disable=SC2034  # Okay if this variable is unused
greenbold='\033[92;1m'
# shellcheck disable=SC2034  # Okay if this variable is unused
cyanbold='\033[96;1m'
# shellcheck disable=SC2034  # Okay if this variable is unused
bluebold='\033[94;1m'

# Print block device info

printf "%b\n" "\n${cyanbold}Your block devices:${normal}"
lsblk -dpo name,hotplug,tran,pttype,size,vendor,model,serial,state

# Warning 10 second countdown

printf "%b\n" "\n${redbold}WARNING: About to erase \
${normal}${bold}${block_device}${normal}"
printf "%b" "10 "
sleep 1
printf "%b" "\r 9 "
sleep 1
printf "%b" "\r 8 "
sleep 1
printf "%b" "\r 7 "
sleep 1
printf "%b" "\r 6 "
sleep 1
printf "%b" "\r 5 "
sleep 1
printf "%b" "\r 4 "
sleep 1
printf "%b" "\r 3 "
sleep 1
printf "%b" "\r 2 "
sleep 1
printf "%b" "\r 1 "
sleep 1
printf "%b\n" "\r 0"
sleep 1

# Wipe old partition information from target block device

printf "%b\n" "\n${redbold}Running ${normal}sgdisk -Z ${block_device}\n"
sgdisk -Z ${block_device}

# Create one partition for exFAT using whole drive

printf "%b\n" "\n${cyanbold}Create partition for exFAT${normal}"
# TODO = set correct sgdisk command
# sgdisk -n 0:0:+1G -c 0:"bootfs" -t 0:ef00 ${block_device}

# See the GPT partition info written to disk

printf "%b\n" "\n${cyanbold}Print partition information${normal}"
sgdisk -p ${block_device}

# Format partition as exFAT

printf "%b\n" "\n${cyanbold}Format partition as exFAT${normal}"
# TODO = exFAT format command

# Review output of lsblk

printf "%b\n" "\n${cyanbold}Review output of lsblk${normal}"
lsblk -o name,hotplug,pttype,label,fstype,fsver,size,partlabel,parttypename
