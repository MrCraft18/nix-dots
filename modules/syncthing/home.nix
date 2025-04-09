{ config, host, ... }:

{
    services.syncthing = {
        enable = true;

        overrideDevices = true;
        overrideFolders = true;

        key = "${config.sops.secrets."syncthing/key/${host}".path}";
        cert = "${config.sops.secrets."syncthing/cert/${host}".path}";

        settings = {
            devices = {
                desktop.id = "5CTVS54-Z3JO4YZ-6EI3LMF-JI3QLVH-HFXOVOX-LORAHZG-TVSOXVV-4KHK6AF";
                netbook.id = "MX37PWP-36UTL36-4SBJISX-LZ7YVLM-LOKNYB7-URBQVAF-XHEDVRM-OURWCQQ";
                zflip.id = "XYEMYY6-66NOUFE-X7FSJEX-R55V35U-35I43JS-AI5N6IV-KXO7ARM-VHR7LAB";
                uconsole.id = "JZ3BXGC-DIXX6BQ-NTKSLIL-62WVYAN-QUOPJU7-TAS753J-ZWQOCJ7-MLVUAQJ";
            };

            folders = {
                "HGames/Favorites" = {
                    path = {
                        desktop = "/home/craft/SSD/Homework/HGames/Favorites";
                        netbook = "/home/craft/Homework/HGames/Favorites";
                        uconsole = "/home/craft/Homework/HGames/Favorites";
                    }."${host}";

                    devices = [
                        "desktop"
                        "netbook"
                        "zflip"
                        "uconsole"
                    ];

                    id = "78e69817-7456-40dc-b0bc-8a8df2212354";
                };

                "HGames/Playing" = {
                    path = {
                        desktop = "/home/craft/SSD/Homework/HGames/Playing";
                        netbook = "/home/craft/Homework/HGames/Playing";
                        uconsole = "/home/craft/Homework/HGames/Playing";
                    }."${host}";

                    devices = [
                        "desktop"
                        "netbook"
                        "zflip"
                        "uconsole"
                    ];

                    id = "4a592e1b-c8e4-4e99-80cc-6db115059db0";
                };
            };
        };
    };
}
