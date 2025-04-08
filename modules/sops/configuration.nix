{ inputs, config, ... }:

{
    home-manager.users.craft.imports = [ ./home.nix ];

    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops = {
        defaultSopsFile = ../../secrets.yaml;
        age.keyFile = "/home/craft/.config/sops/age/keys.txt";

        secrets = {
            "tunnel_service/authkey" = { };
            "tunnel_service/domain" = { };

            "tunnel_service/ports/desktop/ssh" = { };
            "tunnel_service/ports/netbook/ssh" = { };
            "tunnel_service/ports/uconsole/ssh" = { };

            "tunnel_service/ports/old-laptop/ssh" = { };
            "tunnel_service/ports/old-laptop/playwright" = { };

            "tunnel_service/ports/chromebook-a/ssh" = { };
            "tunnel_service/ports/chromebook-a/playwright" = { };

            "tunnel_service/ports/chromebook-b/ssh" = { };
            "tunnel_service/ports/chromebook-b/playwright" = { };

            "syncthing/cert/desktop" = { };
            "syncthing/cert/netbook" = { };
            "syncthing/cert/uconsole" = { };

            "syncthing/key/desktop" = { };
            "syncthing/key/netbook" = { };
            "syncthing/key/uconsole" = { };
        };
    };
}
