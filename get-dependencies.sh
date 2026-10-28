#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm libcanberra ffmpeg firefox

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

mkdir -p ./AppDir/bin
cp -r /usr/lib/firefox/* ./AppDir/bin
find ./AppDir/bin -xtype l -delete
