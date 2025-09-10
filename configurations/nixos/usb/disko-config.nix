{
    disko.devices = {
        disk = {
            main = {
                device = "/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_04012dca57ff294a5e0dc9027004d4149e3657ad9c55907872b31407068274cc5b6600000000000000000000625084c3ff0910188155810766b3209e-0:0";
                type = "disk";
                content = {
                    type = "gpt";
                    partitions = {
                        boot = {
                            size = "1M";
                            type = "EF02"; # for grub MBR
                        };
                        ESP = {
                            size = "1G";
                            type = "EF00";
                            content = {
                                type = "filesystem";
                                format = "vfat";
                                mountpoint = "/boot";
                                mountOptions = [ "umask=0077" ];
                            };
                        };
                        root = {
                            size = "100%";
                            content = {
                                type = "filesystem";
                                format = "ext4";
                                mountpoint = "/";
                            };
                        };
                    };
                };
            };
        };
    };
}
