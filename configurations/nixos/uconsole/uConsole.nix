{pkgs, ...}:

{
    imports = [
        "${builtins.fetchGit {
            url = "https://github.com/NixOS/nixos-hardware.git";
            rev = "cf737e2eba82b603f54f71b10cb8fd09d22ce3f5";
        }}/raspberry-pi/4"
        "${builtins.fetchGit {
            url = "https://github.com/robertjakub/oom-hardware.git";
            rev = "4bd14a023adb06c592193eff2d9195ffd501b059";
        }}/uconsole/kernel"
        "${builtins.fetchGit {
            url = "https://github.com/robertjakub/oom-hardware.git";
            rev = "4bd14a023adb06c592193eff2d9195ffd501b059";
        }}/raspberry-pi/overlays"
        "${builtins.fetchGit {
            url = "https://github.com/robertjakub/oom-hardware.git";
            rev = "4bd14a023adb06c592193eff2d9195ffd501b059";
        }}/raspberry-pi/apply-overlays"
    ];

    nix.distributedBuilds = false;

    nix.settings = {
        substituters = ["https://cache-nix.project2.xyz/uconsole"];
        trusted-substituters = ["https://cache-nix.project2.xyz/uconsole"];
        trusted-public-keys = ["uconsole:t2pv3NWEtXCYY0fgv9BB8r9tRdK+Tz7HYhGq9bXIIck="];
    };

    boot.supportedFilesystems.zfs = false;

    nixpkgs.overlays = [
        (final: super: {
            makeModulesClosure = x:
                super.makeModulesClosure (x // { allowMissing = true; });
        })
    ];

    console = {
        earlySetup = true;
        font = "ter-v32n";
        packages = with pkgs; [terminus_font];
    };

    boot.kernelParams = [
        "8250.nr_uarts=1"
        "vc_mem.mem_base=0x3ec00000"
        "vc_mem.mem_size=0x20000000"
        "console=ttyS0,115200"
        "console=tty1"
        "plymouth.ignore-serial-consoles"
        "snd_bcm2835.enable_hdmi=1"
        "snd_bcm2835.enable_headphones=1"
        "psi=1"
        "iommu=force"
        "iomem=relaxed"
        "swiotlb=131072"
    ];

    hardware.raspberry-pi."4" = {
        xhci.enable = false;
        dwc2.enable = true;
        dwc2.dr_mode = "host";
        overlays = {
            cpu-revision.enable = true;
            audremap.enable = true;
            vc4-kms-v3d.enable = true;
            cpi-disable-pcie.enable = true;
            cpi-disable-genet.enable = true;
            cpi-uconsole.enable = true;
            cpi-i2c1.enable = false;
            cpi-spi4.enable = false;
            cpi-bluetooth.enable = true;
        };
    };

    hardware.deviceTree = {
        enable = true;
        filter = "bcm2711-rpi-cm4.dtb";
        overlaysParams = [
            {
                name = "bcm2711-rpi-cm4";
                params = {
                    ant2 = "on";
                    audio = "on";
                    spi = "off";
                    i2c_arm = "on";
                };
            }
            {
                name = "cpu-revision";
                params = { cm4-8 = "on"; };
            }
            {
                name = "audremap";
                params = {pins_12_13 = "on";};
            }
            {
                name = "vc4-kms-v3d";
                params = {
                    cma-384 = "on";
                    nohdmi1 = "on";
                };
            }
        ];
    };
}
