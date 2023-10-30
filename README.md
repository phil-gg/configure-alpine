# configure-alpine

## Purpose

Configure Alpine Linux in an idempotent manner.

Targets:
 - iSH app
 - an Alpine Linux container
 - an Alpine Linux installation

## Bootstrap

```
busybox wget -qO - https://raw.githubusercontent.com/phil-gg/configure-alpine/main/script-updater.sh | busybox sh
```
