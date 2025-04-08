{ config, ... }:

{
    services.syncthing = {
        enable = true;

        overrideDevices = true;
        overrideFolders = true;

        key = "${config.sops.secrets."syncthing/key/${config.networking.hostName}".path}";
        cert = "${config.sops.secrets."syncthing/cert/${config.networking.hostName}".path}";

        settings = {
            devices = {
                desktop.id = "5CTVS54-Z3JO4YZ-6EI3LMF-JI3QLVH-HFXOVOX-LORAHZG-TVSOXVV-4KHK6AF";
                netbook.id = "MX37PWP-36UTL36-4SBJISX-LZ7YVLM-LOKNYB7-URBQVAF-XHEDVRM-OURWCQQ";
                zflip.id = "XYEMYY6-66NOUFE-X7FSJEX-R55V35U-35I43JS-AI5N6IV-KXO7ARM-VHR7LAB";
            };

            folders = {
                "HGames/Favorites" = {
                    path = {
                        desktop = "/home/craft/SSD/Homework/HGames/Favorites";
                        netbook = "/home/craft/Homework/HGames/Favorites";
                    }."${config.networking.hostname}";

                    devices = [
                        "desktop"
                        "netbook"
                        "zflip"
                    ];

                    id = "78e69817-7456-40dc-b0bc-8a8df2212354";
                };
            };
        };
    };
}
