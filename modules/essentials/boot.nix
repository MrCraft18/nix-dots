{ ... }:

{
    boot.loader = {
        grub = {
            enable = true;
            efiSupport = true;
            devices = [ "nodev" ];
            # useOSProber = true;
        };

        efi.canTouchEfiVariables = true;
    };
}
