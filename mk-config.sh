#!/usr/bin/env bash
#
set -euxo pipefail

# example: make-config usb /dev/sdc

configuration_name="$1"
device="$2"

flake_path="/home/craft/nix-dots"
config_dir="$flake_path/configurations/nixos/$configuration_name"

# make config folder configurations/nixos/<name>

mkdir $config_dir

# copy templates/nixos/default.nix to config folder

cp "$flake_path/templates/nixos/default.nix" "$config_dir/default.nix"

# copy templates/nixos/disko-config.nix to config folder

cp "$flake_path/templates/nixos/disko-config.nix" "$config_dir/disko-config.nix"

# substitute <name> in default-disko-config.nix to device name flag

sed -i "s|<name>|$device|g" "$config_dir/disko-config.nix"

# create hardware-configuration.nix

nixos-generate-config --no-filesystems --show-hardware-config > "$config_dir/hardware-configuration.nix"

# generate temp dir

tmpdir=$(mktemp -d)

# generate ssh client key pair

ssh-keygen -t ed25519 -N "" -f "$tmpdir/id_ed25519" -C "craft@$device" >/dev/null 2>&1

ssh_client_private_key=$(nix run nixpkgs\#jq -- -Rs . < "$tmpdir/id_ed25519")
ssh_client_pub_key=$(cat "$tmpdir/id_ed25519.pub")

# generate age pubkey from ssh client pubkey

age_pub_key=$(nix run nixpkgs\#ssh-to-age -- -i "$tmpdir/id_ed25519.pub")

# clean out tmpdir

rm -rf $tmpdir
tmpdir=$(mktemp -d)

# move ssh_client_pub_key to config folder

echo $ssh_client_pub_key > "$config_dir/ssh_client.pub"

# generate ssh host rsa and ed25519 key pairs

ssh-keygen -t ed25519 -N "" -f "$tmpdir/ssh_host_ed25519_key" >/dev/null 2>&1
ssh-keygen -t rsa -N "" -f "$tmpdir/ssh_host_rsa_key" >/dev/null 2>&1

ssh_host_ed25519_key=$(nix run nixpkgs\#jq -- -Rs . < "$tmpdir/ssh_host_ed25519_key")
ssh_host_rsa_key=$(nix run nixpkgs\#jq -- -Rs . < "$tmpdir/ssh_host_rsa_key")

# remove tmpdir
rm -rf $tmpdir

# add secrets creation rules to .sops.yaml

nix run nixpkgs\#yq-go -- -i "
    .keys.age += [ \"$age_pub_key\" ]
    | .keys.age[-1] anchor = \"$configuration_name\"
    |.creation_rules += [{
        \"path_regex\": \"^configurations/nixos/$configuration_name/secrets.yaml$\",
        \"key_groups\": [ { \"pgp\": [  ], \"age\": [  ] } ]
    }]
    | .creation_rules[-1].key_groups[0].pgp[0] alias |= \"gpg_key\"
    | .creation_rules[-1].key_groups[0].age[0] alias |= \"$configuration_name\"
    | .creation_rules[-1].key_groups[0].pgp style=\"flow\"
    | .creation_rules[-1].key_groups[0].age style=\"flow\"" /home/craft/nix-dots/.sops.yaml

# generate empty secrets.yaml

secrets_file="$config_dir/secrets.yaml"

echo "{}" > $secrets_file
sops -e -i $secrets_file

# add ssh secrets to secrets.yaml

sops --set "[\"ssh\"][\"host\"][\"ed25519\"] $ssh_host_ed25519_key" --in-place "$secrets_file"
sops --set "[\"ssh\"][\"host\"][\"rsa\"] $ssh_host_rsa_key" --in-place "$secrets_file"
sops --set "[\"ssh\"][\"client\"] $ssh_client_private_key" --in-place "$secrets_file"

echo "Done"
