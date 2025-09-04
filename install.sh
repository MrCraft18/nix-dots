#!/usr/bin/env bash
set -euxo pipefail

# example: install usb

configuration_name="$1"
device=$(nix eval --raw --file "configurations/nixos/$configuration_name/disko-config.nix" disko.devices.disk.main.device)

sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake "/home/craft/nix-dots#$configuration_name" --disk main $device
