{ pkgs, inputs, host, ... }:

{
    home-manager.users.craft.imports = [ ./home.nix ];

    services.xserver = {
        enable = true;
        windowManager.i3.enable = true;
    };
}
