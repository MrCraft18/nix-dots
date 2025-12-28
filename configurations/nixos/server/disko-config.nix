{ lib, ... }:

let
    disks = [
        "/dev/disk/by-id/ata-ST8000AS0002-1NA17Z_Z840RBP6"
        "/dev/disk/by-id/ata-ST8000DM004-2CX188_ZCT00FBS" 
        "/dev/disk/by-id/ata-ST8000DM004-2CX188_ZCT00FJA" 
        "/dev/disk/by-id/ata-ST8000AS0002-1NA17Z_Z840WFB1" 
    ];

    mkDisk = { i, path }: {
        name = "disk${toString i}";
        value = {
            type = "disk";
            device = path;
            content = {
                type = "gpt";
                partitions = {
                    ESP = {
                        size = "512M";
                        type = "EF00";
                        content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot-efi/disk${toString i}";
                            mountOptions = [ "umask=0077" ];
                        };
                    };

                    bpool = {
                        size = "4G";
                        content = {
                            type = "zfs";
                            pool = "bpool";
                        };
                    };

                    rpool = {
                        size = "100%";
                        content = {
                            type = "zfs";
                            pool = "rpool";
                        };
                    };
                };
            };
        };
    };

    mkDisks = paths: lib.listToAttrs (lib.imap1 (i: path: mkDisk { inherit i path; }) paths);
in {
    disko.devices = {
        disk = mkDisks disks;

        zpool = {
            bpool = {
                type = "zpool";
                mode = "mirror";
                # mountpoint = "/boot";
                options = {
                    ashift = "12";
                };
                rootFsOptions = {
                    devices = "off";
                    acltype = "posixacl";
                    xattr = "sa";
                    compression = "lz4";
                    normalization = "formD";
                    relatime = "on";
                    canmount = "off";

                    "com.sun:auto-snapshot" = "false";
                };
                datasets = {
                    "boot" = {
                        type = "zfs_fs";
                        mountpoint = "/boot";
                    };
                };
            };

            rpool = {
                type = "zpool";
                mode = "raidz2";
                # mountpoint = "/";

                options = {
                    ashift = "12";
                };

                rootFsOptions = {
                    compression = "zstd";
                    xattr = "sa";
                    atime = "off";
                    "com.sun:auto-snapshot" = "false";
                };

                datasets = {
                    "root" = {
                        type = "zfs_fs";
                        mountpoint = "/";
                    };
                    # "nix" = {
                    #     type = "zfs_fs";
                    #     mountpoint = "/nix";
                    # };
                    # "home" = {
                    #     type = "zfs_fs";
                    #     mountpoint = "/home";
                    # };
                };
            };
        };
    };
}
