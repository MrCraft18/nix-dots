{ config, ... }:

{
    sops.secrets."craft_password" = {
        neededForUsers = true;
        sopsFile = ../../secrets.yaml;
    };

    users.mutableUsers = false;
    users.users.craft = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "video" "input" ];
        hashedPasswordFile = config.sops.secrets."craft_password".path;

        openssh.authorizedKeys.keyFiles = map (name: ../../configurations/nixos + "/${name}/ssh_client.pub") (builtins.attrNames (builtins.readDir ../../configurations/nixos));
        # openssh.authorizedKeys.keys = [
        #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAlvRA8dmnopz4KqdRhC4fPGkBGKA+SnTbw9ubFSEVD4 craft@desktop"
        #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIlIQ73VqgtCDpdlaUcskdpRNteq6Bb6D8YnDF/enp7K craft@netbook"
        #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWz8lyOKlKD3XfiYq8ZPwpLszoWRXYltCBVvQB1JQT/ nix-on-droid@localhost"
        #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIS6/tzfk88+XtidEH8GLbDX3uf1OZ6lCL6MfDzJO5zP craft@panasonic"
        # ];
    };
}
