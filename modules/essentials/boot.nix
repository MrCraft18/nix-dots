{ ... }:

{
    # boot.loader.grub.enable = true;
    # boot.loader.grub.efiSupport = true;
    # boot.loader.grub.efiInstallAsRemovable = true;

    boot.loader = {
        systemd-boot.enable = true;

        # grub = {
        #     enable = true;
        #     efiSupport = true;
        #     devices = [ "nodev" ];
        #     # useOSProber = true;
        # };
        # efi.canTouchEfiVariables = true;
        # efi.efiSysMountPoint = "/boot";
    };
}
