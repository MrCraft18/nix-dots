{ config, host, ... }:

{
    services.hyprpaper = {
        enable = true;

        settings = if host == "uconsole" then {
            preload = [
                "${config.home.homeDirectory}/nix-dots/modules/hyprland/walls/uconsole.png"
            ];

            wallpaper = [
                ", ${config.home.homeDirectory}/nix-dots/modules/hyprland/walls/uconsole.png"
            ];
        } else {};
    };
}
