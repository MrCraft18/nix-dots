{
    disko.devices = {
        disk = {
            main = {
                device = "/dev/disk/by-id/usb-PNY_USB_2.0_FD_AAB81A01000000B8-0:0";
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
