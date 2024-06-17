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

# Set variables

block_device="/dev/nvme0n1"
normal=$(printf '\033[0m')
redbold=$(printf '\033[91;1m')
greenbold=$(printf '\033[92;1m')
cyanbold=$(printf '\033[96;1m')
bluebold=$(printf '\033[94;1m')

# Warning 10 second countdown

# TO-DO = Add countdown here

# Partitioning scheme for block device:
# (1) 1G (Gibibyte) "Bootfs" right at start (FAT32).
# (2) 10G (Gibibyte) "Swapfs" +129M (Mebibytes) after Bootfs.
# (3) "Rootfs" +129M after Swapfs and ending -129M from end of device.

# 
