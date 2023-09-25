#!/bin/sh

################################################################################
# Auto-update companion script for `configure-alpine.sh`.
#
# Choice of shebang allows for execution by busybox.
# (i.e. run this file with `busybox sh script-updater.sh`)
#
# This shell script attempts to comply with:
# https://google.github.io/styleguide/shellguide.html
################################################################################

# Set variables

github_username="phil-gg"
github_project="configure-alpine"
github_branch="main"
runtime=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
normal=$(printf '\033[0m')
redbold=$(printf '\033[91;1m')
greenbold=$(printf '\033[92;1m')
cyanbold=$(printf '\033[96;1m')
bluebold=$(printf '\033[94;1m')

# Alpine version check

  # Only run this type of version check on iSH app

str1=$(cut -b 1-3 /proc/ish/version)
str2="iSH"
if [ "$str1" = "$str2" ]; then

  # Version check logic just for the iSH app

# Check for presence of lynx

echo -e "\n${bluebold}Installing lynx${normal}"

cat /etc/apk/world | grep lynx 1> /dev/null

if [ $? -ne 0 ]; then
apk add lynx
fi

echo -e "\n${bluebold}Alpine version check${normal}"

installedversion=$(cut -b 5- /proc/ish/version \
| cut -d " " -f1 )

echo "Installed version = \
${cyanbold}${installedversion}${normal}"

installedbuild=$(cut -b 5- /proc/ish/version \
| cut -d "(" -f2 \
| cut -d ")" -f1 )

echo "Installed build = \
${cyanbold}${installedbuild}${normal}"

lynxoutput=$(lynx -dump \
"https://apps.apple.com/au/app/ish-shell/id1436902243" \
| grep -- 'Version' )

latestversion=$(echo ${lynxoutput} | sed -r 's/[^0-9\.]+//g' $1 )

echo "Latest version = \
${cyanbold}${latestversion}${normal}"

if [ "$installedversion" = "$latestversion" ]; then
    echo "${greenbold}  iSH app is up-to-date${normal}"
else
    echo "${redbold}  Update iSH from app store${normal}"
fi

  # Version check logic for iSH running on podman
  # TODO: Add an else and then version check code here

fi

# Network test

echo -e "\n${bluebold}Testing network connectivity${normal}"

wget -q --spider https://raw.githubusercontent.com\
/${github_username}\
/${github_project}\
/${github_branch}\
/configure-alpine.sh 2> /dev/null

if [ $? -eq 0 ]; then
echo "${greenbold}  Online${normal}"
else
echo "${redbold}  Offline${normal}"
exit 101
fi

# Working directory (and create if does not exist)

cd /
mkdir -p git
cd /git
mkdir -p ${github_username}
cd ${github_username}
mkdir -p ${github_project}
cd ${github_project}

# Save last run time to working directory

echo ${runtime} > lastrun-upd.txt

# Save latest versions of scripts to working directory

echo -e "\n${bluebold}Update these scripts from github${normal}"

# TODO: Change to git clone here
# Only keep one latest version
# Include check for presence of git (just like lynx above)

wget -qO script-updater.sh \
https://raw.githubusercontent.com\
/${github_username}\
/${github_project}\
/${github_branch}\
/script-updater.sh 2> /dev/null

if [ $? -eq 0 ]; then
echo "${greenbold}  Successfully updated ‘script-updater.sh’${normal}"
else
echo "${redbold}  Updating ‘script-updater.sh’ failed${normal}"
exit 102
fi

wget -qO configure-alpine.sh \
https://raw.githubusercontent.com\
/${github_username}\
/${github_project}\
/${github_branch}\
/configure-alpine.sh 2> /dev/null

if [ $? -eq 0 ]; then
echo "${greenbold}  Successfully updated ‘configure-alpine.sh’${normal}"
else
echo "${redbold}  Updating ‘configure-alpine.sh’ failed${normal}"
exit 103
fi

# Now run configure-alpine.sh

echo -e "\n${bluebold}Run ‘configure-alpine.sh’${normal}"

busybox sh configure-alpine.sh
