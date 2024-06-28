#!/bin/sh

################################################################################
# Download Alpine, checksum, and write to block device.
#
# Choice of shebang allows for execution by busybox.
# (i.e. run this file with `busybox sh 02-alpine-onto-blk-dev.sh`)
#
# This shell script attempts to comply with:
# https://google.github.io/styleguide/shellguide.html
################################################################################

# Set variables

block_device="/dev/nvme0n1"
dlurl="https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/"
arch="aarch64"
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

# Network test

printf "%b\n" "\n${bluebold}Testing network connectivity${normal}"

wget -q --spider "${dlurl}${arch}/latest-releases.yaml" 2> /dev/null

# shellcheck disable=SC2181  # Okay with doing this check indirectly
if [ $? -eq 0 ];
  then
    printf "%b\n" "${greenbold}Online${normal}"
  else
    printf "%b\n" "${redbold}Offline${normal}"
    exit 101
fi

# Get (and print) Alpine download file details

# shellcheck disable=SC2086  # Variables won't glob or word split here
dlfile="$(wget -qO - ${dlurl}${arch}/latest-releases.yaml \
| grep -om 1 "alpine-rpi-[0-9.]*-aarch64.tar.gz")"

# shellcheck disable=SC2086  # Variables won't glob or word split here
alpinefolder="$(wget -qO - ${dlurl}${arch}/latest-releases.yaml \
| grep -om 1 "alpine-rpi-[0-9.]*-aarch64")"

# shellcheck disable=SC2086  # Variables won't glob or word split here
sha256="$(wget -qO - ${dlurl}${arch}/${dlfile}.sha256)"

# shellcheck disable=SC2086  # Variables won't glob or word split here
sha512="$(wget -qO - ${dlurl}${arch}/${dlfile}.sha512)"

printf "%b\n" "\n${cyanbold}Alpine download file details${normal}"
printf "%b\n" "${dlfile}"
printf "%b\n" "SHA256:"
# shellcheck disable=SC2086  # Variable won't glob or word split here
printf "%b\n" "$(echo ${sha256} | head -c 64 | fold -w 32)"
printf "%b\n" "SHA512:"
# shellcheck disable=SC2086  # Variable won't glob or word split here
printf "%b\n" "$(echo ${sha512} | head -c 128 | fold -w 32)"

# Check for pre-existing Alpine download and download if needed

printf "%b\n" "\n${bluebold}Testing presence of Alpine download${normal}"
if test -e "${dlfile}";
  then
    printf "%b\n" "${greenbold}File exists${normal}"
  else
    printf "%b\n" "File does not exist"
    printf "%b\n" "\n${cyanbold}Downloading Alpine${normal}"
    wget -O "${dlfile}" "${dlurl}${arch}/${dlfile}"
fi

# Analyse checksum

printf "%b\n" "\n${bluebold}Compare Alpine download to checksum${normal}"
echo "${sha256}" | sha256sum -c
# shellcheck disable=SC2181  # Okay with doing this check indirectly
if [ $? -eq 0 ];
  then
    printf "%b\n" "${greenbold}SUCCESS: sha512 matches${normal}"
  else
    printf "%b\n" "${redbold}ERROR: sha512 mismatch${normal}\n"
    exit 103
fi
echo "${sha512}" | sha512sum -c
# shellcheck disable=SC2181  # Okay with doing this check indirectly
if [ $? -eq 0 ];
  then
    printf "%b\n" "${greenbold}SUCCESS: sha512 matches${normal}"
  else
    printf "%b\n" "${redbold}ERROR: sha512 mismatch${normal}\n"
    exit 103
fi

# Unpack Alpine download

printf "%b\n" "\n${cyanbold}Unpacking Alpine download${normal}"
if [ -d "${alpinefolder}" ]
  then
    rm -rf "${alpinefolder}"
fi
mkdir "${alpinefolder}"
tar -xzvf "${dlfile}" -C "${alpinefolder}"
# shellcheck disable=SC2086  # Variable won't glob or word split here
rm ./${alpinefolder}/config.txt
cp ./config.txt ./${alpinefolder}/config.txt
cp ./config.txt ./${alpinefolder}/usercfg.txt

# Install Alpine download

printf "%b\n" "\n${cyanbold}Installing Alpine to target block device${normal}"


# Finally make a suggestion to clean up Alpine download file

printf "%b\n" "\n${cyanbold}Remove Alpine download (not yet executed)${normal}"
# shellcheck disable=SC2086  # Variable won't glob or word split here
printf "%b\n" "rm ${dlfile} && rm -rf ${alpinefolder}\ngit reset --hard\n"
