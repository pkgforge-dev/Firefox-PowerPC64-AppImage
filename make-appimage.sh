#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q firefox | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export DESKTOP=https://gitlab.archlinux.org/archlinux/packaging/packages/firefox/-/raw/main/firefox.desktop
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export URUNTIME_PRELOAD=1

# Deploy dependencies
LD_LIBRARY_PATH=$PWD/AppDir/bin quick-sharun \
  /usr/lib/libavcodec.so* \
  /usr/lib/libcanberra.so* \
  /usr/bin/firefox

echo 'MOZ_LEGACY_PROFILES=1' >>./AppDir/.env
echo 'MOZ_APP_LAUNCHER=${APPIMAGE}' >>./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
