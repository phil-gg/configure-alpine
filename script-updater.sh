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

# Now running `script-updater.sh`

echo -e "\n${cyanbold}Now running ‘script-updater.sh’${normal}"

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

# Set run time for this latest `Update` operation

echo "${runtime}" > lastrun-upd.txt
echo -e "\n${bluebold}Update run at${normal}"
echo -e "  ${runtime}"

# iSH version check

  # Only run this version check on iSH app

str1=$(cut -b 1-3 /proc/ish/version 2> /dev/null)
str2="iSH"
if [ "$str1" = "$str2" ]; then

  # Check for presence of lynx

grep lynx /etc/apk/world 1> /dev/null

if [ $? -ne 0 ]; then
echo -e "\n${bluebold}Installing lynx${normal}"
apk add lynx
fi

  # Check version of iSH

echo -e "\n${bluebold}iSH version check${normal}"

installedversion=$(cut -b 5- /proc/ish/version \
| cut -d " " -f1 )

echo "  Installed version = \
${cyanbold}${installedversion}${normal}"

installedbuild=$(cut -b 5- /proc/ish/version \
| cut -d "(" -f2 \
| cut -d ")" -f1 )

echo "  Installed build = \
${cyanbold}${installedbuild}${normal}"

lynxoutput=$(lynx -dump \
"https://apps.apple.com/au/app/ish-shell/id1436902243" \
| grep -- 'Version' )

latestversion=$(echo "${lynxoutput}" | sed -r 's/[^0-9\.]+//g')

echo "  Latest version = \
${cyanbold}${latestversion}${normal}"

if [ "$installedversion" = "$latestversion" ]; then
    echo "${greenbold}  iSH app is up-to-date${normal}"
else
    echo "${redbold}  Update iSH from app store${normal}"
fi
  # End of logic just for the iSH app
fi

# Check for presence of git

grep git /etc/apk/world 1> /dev/null

if [ $? -ne 0 ]; then
echo -e "\n${bluebold}Installing git${normal}"
apk add git
fi

# Check for presence of git config

git config --list | grep "init.defaultbranch=main" 1> /dev/null

if [ $? -ne 0 ]; then
git config --global init.defaultbranch main
fi

# Working directory (and create if does not exist)

cd /
mkdir -p git
cd /git
mkdir -p "${github_username}"
cd "${github_username}"
mkdir -p "${github_project}"
cd "${github_project}"

# Sync project to working directory with git

echo -e "\n${bluebold}Sync project with github${normal}"

git status &> /dev/null

if [ $? -eq 128 ]; then
echo "  .git not created yet"

echo -e "\n${bluebold}git init${normal}"
git init

echo -e "\n${bluebold}git remote add origin
https://github.com\
/${github_username}\
/${github_project}.git\
${normal}"
git remote add origin "https://github.com\
/${github_username}\
/${github_project}.git"

echo -e "\n${bluebold}git fetch${normal}"
git fetch

echo -e "\n${bluebold}git checkout main -f${normal}"
git checkout main -f

echo -e "\n${bluebold}git branch --set-upstream-to \
\"origin/${github_branch}\"${normal}"
git branch --set-upstream-to "origin/${github_branch}"

fi

# TODO: git status check and echo status result & actions here for local behind

# TODO: git status check and echo status result if you need to review git

<< '###'

wget -qO script-updater.sh "\
https://raw.githubusercontent.com\
/${github_username}\
/${github_project}\
/${github_branch}\
/script-updater.sh" 2> /dev/null

if [ $? -eq 0 ]; then
echo "${greenbold}  Successfully updated ‘script-updater.sh’${normal}"
else
echo "${redbold}  Updating ‘script-updater.sh’ failed${normal}"
exit 102
fi

wget -qO configure-alpine.sh "\
https://raw.githubusercontent.com\
/${github_username}\
/${github_project}\
/${github_branch}\
/configure-alpine.sh" 2> /dev/null

if [ $? -eq 0 ]; then
echo "${greenbold}  Successfully updated ‘configure-alpine.sh’${normal}"
else
echo "${redbold}  Updating ‘configure-alpine.sh’ failed${normal}"
exit 103
fi

###

# Now running `configure-alpine.sh`

echo -e "\n${cyanbold}Now running ‘configure-alpine.sh’${normal}"

busybox sh configure-alpine.sh
