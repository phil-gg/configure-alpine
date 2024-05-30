# configure-alpine

## Purpose

Configure Alpine Linux in an idempotent manner.

Targets:
 - [iSH Shell](https://ish.app/) (_[on App Store](https://apps.apple.com/us/app/ish-shell/id1436902243)_)
 - A Raspberry Pi Compute Module 4 (_[Mouser](https://au.mouser.com/ProductDetail/Raspberry-Pi/SC0675?qs=T%252BzbugeAwjhgf8s%252BsmfpGA%3D%3D),[Documentation](https://datasheets.raspberrypi.com/cm4/cm4-datasheet.pdf)_) on Piunora Pro (_[Mouser](https://au.mouser.com/ProductDetail/Diodes-Delight/DD-PIUNO-PRO?qs=sGAEpiMZZMu3sxpa5v1qrleB2ZU0msEUH0DVqXHjiRs%3D), [Documentation](https://www.diodes-delight.com/docs/piunora/)_) carrier board

## Bootstrap

```
busybox wget -qO - https://raw.githubusercontent.com/phil-gg/configure-alpine/main/script-updater.sh | busybox sh
```
