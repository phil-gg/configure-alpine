#!/bin/sh

################################################################################
# Configure Alpine Linux in an idempotent manner.
#
# See `#term-Idempotency` definition at:
# https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html
#
# Choice of shebang allows for execution by busybox symlinks.
#
# This shell script attempts to comply with:
# https://google.github.io/styleguide/shellguide.html
################################################################################

################################################################################
#
# Line wrap ruler
#
# - 5 - 10   15   20   25   30   35   40   45   50   55   60   65   70   75   80
#
################################################################################

cd /

echo '
One
Two
Three
' > test.txt

# Dockerfile commented out with : '

: '
FROM --platform=linux/amd64 alpine:latest
RUN
ENTRYPOINT
 '
