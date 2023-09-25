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

# Network test

echo "Step 1: Testing network connectivity"
wget -q --spider https://raw.githubusercontent.com\
/${github_username}\
/${github_project}\
/${github_branch}\
/configure-alpine.sh 2> /dev/null

if [ $? -eq 0 ]; then
echo "${greenbold}        Online${normal}"
else
echo "${redbold}        Offline${normal}"
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

# Save latest version of script to working directory

wget -qO configure-alpine.sh \
https://raw.githubusercontent.com\
/${github_username}\
/${github_project}\
/${github_branch}\
/configure-alpine.sh

################################################################################
#
# Line wrap ruler
#
#   5   10   15   20   25   30   35   40   45   50   55   60   65   70   75   80
#
################################################################################

# Test creating file in working directory

echo -ne "\
${runtime}
One
Two
Three
" > test.txt

# Get Installed version number and Installed build number from this:

cat /proc/ish/version

# Get Latest version number from this:

lynx -dump "https://apps.apple.com/au/app/ish-shell/id1436902243" -- | grep Version

# Dockerfile commented out with : '

: '
FROM --platform=linux/amd64 alpine:latest
RUN
ENTRYPOINT
 '
