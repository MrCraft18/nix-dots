#!/usr/bin/env bash
set -euxo pipefail

# example: install usb

configuration_name="$1"
# device=$(nix eval --raw --file "configurations/nixos/$configuration_name/disko-config.nix" disko.devices.disk.main.device)

# run disko command

sudo nix run github:nix-community/disko/latest -- --root-mountpoint /mnt/nixos-install --mode destroy,format,mount "configurations/nixos/$configuration_name/disko-config.nix"

# generate age key pair

tmpdir=$(mktemp -d)

sops -d "configurations/nixos/$configuration_name/secrets.yaml" | nix run nixpkgs#yq-go -- -r '.ssh.client' > "$tmpdir/ssh_client"

sudo mkdir -p /mnt/nixos-install/home/craft/.config/sops/age

sudo nix run nixpkgs#ssh-to-age -- -private-key -i "$tmpdir/ssh_client" -o /mnt/nixos-install/home/craft/.config/sops/age/key.txt

sudo chown -R craft:"$(id -gn craft)" /mnt/nixos-install/home/craft

rm -rf $tmpdir

# run nixos install

cd /mnt/nixos-install
sudo nixos-install --no-root-password --root /mnt/nixos-install --flake /home/craft/nix-dots#$configuration_name
