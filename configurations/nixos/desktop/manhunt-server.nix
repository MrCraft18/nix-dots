{ inputs, pkgs, ... }:

let
    serverName = "manhunt-1_21_11";
    serverUnit = "minecraft-server-${serverName}.service";
in
{
    imports = [
        inputs.nix-minecraft.nixosModules.minecraft-servers
    ];

    nixpkgs.overlays = [
        inputs.nix-minecraft.overlay
    ];

    environment.systemPackages = [
        (pkgs.writeShellScriptBin "manhunt-reset-world" ''
            set -euo pipefail
            echo "Resetting Manhunt World..."
            sudo systemctl stop "${serverUnit}"
            sudo rm -rf "/srv/minecraft/manhunt-1_21_11/world"
            sudo systemctl start "${serverUnit}"
            echo "Done"
        '')
    ];

    services.minecraft-servers = {
        enable = true;
        eula = true;

        managementSystem = {
            tmux.enable = false;
            systemd-socket.enable = true;
        };

        servers.manhunt-1_21_11 = {
            enable = true;

            package = pkgs.fabricServers.fabric-1_21_11;

            jvmOpts = "-Xms8G -Xmx8G";

            operators = {
                "Mr_Craft" = "6cc6dfb3-be27-4fa8-ae40-18c53fcb10ff";
            };

            serverProperties = {
                allow-flight = true;
                difficulty = "easy";
                motd = "Craft's Manhunt";
                spawn-protection = 0;
                view-distance = 16;
            };

            files = {
                "world/datapacks/locator-bar-off/pack.mcmeta" = {
                    format = pkgs.formats.json { };
                    value = {
                        pack = {
                            description = "Set server gamerules";
                            min_format = [ 94 1 ];
                            max_format = [ 94 1 ];
                        };
                    };
                };
                "world/datapacks/locator-bar-off/data/minecraft/tags/function/load.json".value = {
                    values = [ "server:gamerules" ];
                };
                "world/datapacks/locator-bar-off/data/server/function/gamerules.mcfunction" = pkgs.writeText "gamerules.mcfunction" ''
                    gamerule locator_bar false
                '';

                "config/trackercompass.json".value = {
                    compassUpdateTicks = 10;
                    enableTrackerGui = true;
                    actionBarInfo = true;
                    onlyShowWhenHoldingCompass = true;
                    showDistance = false;
                    showDirectionArrow = false;
                    showDimension = false;
                    showStatusIndicators = true;
                    giveCompassByDefault = true;
                    showOfflinePlayersInGui = true;
                };
            };

            symlinks = {
                mods = pkgs.linkFarmFromDrvs "mods" (
                    builtins.attrValues {
                        Manhunt = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/6jEbbeXn/versions/ITfxk5Q6/trackercompass-0.0.5%2B1.21.11.jar"; sha512 = "54f9e528fc7c5ce566db446b720ddd23827d0df39d8ec33fbfaf728686480935cdcc9829f073620578575b887be2cd24a4fddbc2ecad66efc9f12324b008066a"; };

                        FabricAPI = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/i5tSkVBH/fabric-api-0.141.3%2B1.21.11.jar"; sha512 = "c20c017e23d6d2774690d0dd774cec84c16bfac5461da2d9345a1cd95eee495b1954333c421e3d1c66186284d24a433f6b0cced8021f62e0bfa617d2384d0471"; };
                        FerriteCore = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/uXXizFIs/versions/Ii0gP3D8/ferritecore-8.2.0-fabric.jar"; sha512 = "3210926a82eb32efd9bcebabe2f6c053daf5c4337eebc6d5bacba96d283510afbde646e7e195751de795ec70a2ea44fef77cb54bf22c8e57bb832d6217418869"; };
                        Lithium = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/gl30uZvp/lithium-fabric-0.21.2%2Bmc1.21.11.jar"; sha512 = "94625510013e0daaf1c2e2b6d8a463c932ff6220f91ba5b0cd5f868658215f046d94d07b3465660f576c4dc27a5aa183dfbdc1c9303f11894b5b25a1dc6c3bb6"; };
                        AppleSkin = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/59ti1rvg/appleskin-fabric-mc1.21.11-3.0.8.jar"; sha512 = "d32206cb8d6fac7f0b579f7269203135777283e1639ccb68f8605e9f5469b5b54305fd36ba82c64b48b89ae4f1a38501bfb5827284520c3ec622d95edcfa34de"; };
                        ModernFix = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/TjSm1wrD/versions/JwSO8JCN/modernfix-5.25.2-build.4.jar"; sha512 = "0d65c05ac0475408c58ef54215714e6301113101bf98bfe4bb2ba949fbfddd98225ac4e2093a5f9206a9e01ba80a931424b237bdfa3b6e178c741ca6f7f8c6a3"; };
                        Krypton = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/O9LmWYR7/krypton-0.2.10.jar"; sha512 = "4dcd7228d1890ddfc78c99ff284b45f9cf40aae77ef6359308e26d06fa0d938365255696af4cc12d524c46c4886cdcd19268c165a2bf0a2835202fe857da5cab"; };
                        C2ME = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/VSNURh3q/versions/QdLiMUjx/c2me-fabric-mc1.21.11-0.3.7%2Balpha.0.7.jar"; sha512 = "f9543febe2d649a82acd6d5b66189b6a3d820cf24aa503ba493fdb3bbd4e52e30912c4c763fe50006f9a46947ae8cd737d420838c61b93429542573ed67f958e"; };
                    }
                );
            };
        };
    };
}
