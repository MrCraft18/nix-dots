{ ... }:

{
    boot.loader = {
        systemd-boot.enable = false;

        grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
            # useOSProber = true;
        };

        # efi.canTouchEfiVariables = true;
    };
    boot.loader.grub.efiInstallAsRemovable = true;
}
