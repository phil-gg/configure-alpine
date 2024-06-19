#!/bin/sh

################################################################################
# Block device set-up script.
#
# Choice of shebang allows for execution by busybox.
# (i.e. run this file with `busybox sh 02-alpine-onto-blk-dev.sh`)
#
# This shell script attempts to comply with:
# https://google.github.io/styleguide/shellguide.html
################################################################################

# Set variables

block_device="/dev/nvme0n1"
# shellcheck disable=SC2034  # Okay if this variable is unused
normal='\033[0m'
# shellcheck disable=SC2034  # Okay if this variable is unused
redbold='\033[91;1m'
# shellcheck disable=SC2034  # Okay if this variable is unused
greenbold='\033[92;1m'
# shellcheck disable=SC2034  # Okay if this variable is unused
cyanbold='\033[96;1m'
# shellcheck disable=SC2034  # Okay if this variable is unused
bluebold='\033[94;1m'

# Get (and print) Alpine download file details

dlurl="$(busybox wget -qO - https://dl-cdn.alpinelinux.org\
/alpine/latest-stable/releases/aarch64/latest-releases.yaml \
| grep -om 1 alpine-rpi-[0-9.]*-aarch64.tar.gz)"

# shellcheck disable=SC2086  # Variable won't glob or word split here
sha256="$(busybox wget -qO - https://dl-cdn.alpinelinux.org\
/alpine/latest-stable/releases/aarch64/${dlurl}.sha256)"

# shellcheck disable=SC2086  # Variable won't glob or word split here
sha512="$(busybox wget -qO - https://dl-cdn.alpinelinux.org\
/alpine/latest-stable/releases/aarch64/${dlurl}.sha512)"

printf "%b\n" "\n${cyanbold}Alpine download url${normal}"
printf "%b\n" "${dlurl}"
printf "%b\n" "SHA256:"
# shellcheck disable=SC2086  # Variable won't glob or word split here
printf "%b\n" "$(echo ${sha256} | head -c 64)" | fold -w 32
printf "%b\n" "SHA512:"
# shellcheck disable=SC2086  # Variable won't glob or word split here
printf "%b\n" "$(echo ${sha512} | head -c 128)" | fold -w 32
