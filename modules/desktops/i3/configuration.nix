{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.desktop;
in {
    config = lib.mkIf (cfg == "i3") {
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
    };
}
