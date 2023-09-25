#!/bin/sh

################################################################################
# Configure Alpine Linux in an idempotent manner.
#
# See `#term-Idempotency` definition at:
# https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html
#
# Choice of shebang allows for execution by busybox.
# (i.e. run this file with `busybox sh configure-alpine.sh`)
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

echo -e "\n${bluebold}Alpine version check${normal}"

  # Only run this type of version check on iSH app

if [$(cut -b 1-3 /proc/ish/version) -eq 'iSH']; then

installedversion=$(cut -b 5- /proc/ish/version \
| cut -d " " -f1 )

echo "Installed version = \
${cyanbold}${installedversion}${normal}"

installedbuild=$(cut -b 5- /proc/ish/version \
| cut -d "(" -f2 \
| cut -d ")" -f1 )

echo "Installed build = \
${cyanbold}${installedbuild}${normal}"

cat /etc/apk/world | grep lynx 1> /dev/null

if [ $? -ne 0 ]; then
apk add lynx
fi

lynxoutput=$(lynx -dump \
"https://apps.apple.com/au/app/ish-shell/id1436902243" \
| grep -- 'Version' )

latestversion=$(echo ${lynxoutput} | sed -r 's/[^0-9\.]+//g' $1 )

echo "Latest version = \
${cyanbold}${latestversion}${normal}"

  # Version check for iSH running on podman
  # Add an else and then version check code here

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

# Save latest versions of scripts to working directory

echo -e "\n${bluebold}Update these scripts from github${normal}"

wget -qO configure-alpine.sh \
https://raw.githubusercontent.com\
/${github_username}\
/${github_project}\
/${github_branch}\
/configure-alpine.sh 2> /dev/null

if [ $? -eq 0 ]; then
echo "${greenbold}  Successfully updated ‘configure-alpine.sh’${normal}"
else
echo "${redbold}  Updating ’configure-alpine.sh’ failed${normal}"
exit 102
fi

# The above should be separate file script-updater.sh

# Now run the updated script you have just downloaded

# busybox sh configure-alpine.sh

################################################################################
#
# Line wrap ruler
#
#   5   10   15   20   25   30   35   40   45   50   55   60   65   70   75   80
#
################################################################################

# Test creating file in working directory

echo -n "\
${runtime}
One
Two
Three
" > test.txt

# Dockerfile (commented out)
# FROM --platform=linux/amd64 alpine:latest
# RUN
# ENTRYPOINT
