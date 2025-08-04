{ inputs, config, ... }:

{
    home-manager.users.craft.imports = [ ./home.nix ];

    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops = {
        defaultSopsFile = ../../secrets.yaml;
        age.keyFile = "/home/craft/.config/sops/age/keys.txt";

        secrets = {
            "syncthing/cert/desktop" = { };
            "syncthing/cert/netbook" = { };
            "syncthing/cert/uconsole" = { };

            "syncthing/key/desktop" = { };
            "syncthing/key/netbook" = { };
            "syncthing/key/uconsole" = { };
        };
    };
}
