{ host, ... }:

{
    services.hyprpaper = {
        enable = true;

        settings = if host == "uconsole" then {
            preload = [
                "/home/craft/nix-dots/modules/hyprland/walls/uconsole.png"
            ];

            wallpaper = [
                ", /home/craft/nix-dots/modules/hyprland/walls/uconsole.png"
            ];
        } else {};
    };
}
