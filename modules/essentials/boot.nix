{ lib, ... }:

{
    boot.loader = {
        grub = {
            enable = lib.mkDefault true;
            efiSupport = lib.mkDefault true;
            devices = lib.mkDefault [ "nodev" ];
            # useOSProber = true;
        };

        efi.canTouchEfiVariables = lib.mkDefault true;
    };
}
