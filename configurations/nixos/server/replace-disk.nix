{
    disko.devices.disk.disk4 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST8000AS0002-1NA17Z_Z840WFB1" ;
        content = {
            type = "gpt";
            partitions = {
                ESP = {
                    size = "512M";
                    type = "EF00";
                    content = {
                        type = "filesystem";
                        format = "vfat";
                        mountpoint = "/boot-efi/disk4";
                        mountOptions = [ "umask=0077" ];
                    };
                };

                bpool = {
                    size = "4G";
                    # content = {
                    #     type = "zfs";
                    #     pool = "bpool";
                    # };
                };

                rpool = {
                    size = "100%";
                    # content = {
                    #     type = "zfs";
                    #     pool = "rpool";
                    # };
                };
            };
        };

    };
}
