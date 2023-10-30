# configure-alpine

## Purpose

Configure Alpine Linux in an idempotent manner.

Targets:
 - [iSH Shell](https://ish.app/) (_[on App Store](https://apps.apple.com/us/app/ish-shell/id1436902243)_)
 - an Alpine Linux container
 - an Alpine Linux installation

## Bootstrap

```
busybox wget -qO - https://raw.githubusercontent.com/phil-gg/configure-alpine/main/script-updater.sh | busybox sh
```
