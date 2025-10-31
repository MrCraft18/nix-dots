{ inputs, config, ... }:

{
    sops.secrets."craft_password" = {
        neededForUsers = true;
        sopsFile = "${inputs.self}/secrets.yaml";
    };

    users.mutableUsers = false;
    users.users.craft = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "video" "input" ];
        hashedPasswordFile = config.sops.secrets."craft_password".path;

        openssh.authorizedKeys.keyFiles = map (name: ../../configurations/nixos + "/${name}/ssh_client.pub") (builtins.attrNames (builtins.readDir ../../configurations/nixos));
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWz8lyOKlKD3XfiYq8ZPwpLszoWRXYltCBVvQB1JQT/ nix-on-droid@localhost"
        ];
    };
}
