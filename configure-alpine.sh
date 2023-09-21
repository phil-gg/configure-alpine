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

runtime=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
github_username="phil-gg"
github_project="configure-alpine"
github_branch="main"

# Working directory (and create if does not exist)

cd /
mkdir -p git
cd /git
mkdir -p ${github_username}
cd /git/${github_username}
mkdir -p ${github_project}
cd /git/${github_username}/${github_project}

# Save latest version of script to working directory

wget -O configure-alpine.sh \
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

echo -ne "
${runtime}
One
Two
Three
" > test.txt

# Get Installed version number and Installed build number from this:

cat /proc/ish/verson

# Get Latest version number from this:

lynx -dump https://apps.apple.com/au/app/ish-shell/id1436902243 | grep Version

# Dockerfile commented out with : '

: '
FROM --platform=linux/amd64 alpine:latest
RUN
ENTRYPOINT
 '
