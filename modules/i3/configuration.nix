{ pkgs, inputs, host, ... }:

{
    home-manager.users.craft.imports = [ ./home.nix ];

    services.xserver = {
        enable = true;
        displayManager.startx.enable = true;

        windowManager.i3.enable = true;

        config = ''
            Section "Device"
                Identifier "Intel Graphics"
                Driver "modesetting"
                Option "TearFree" "true"
            EndSection
        '';
    };

    hardware.graphics.enable = true;
}
