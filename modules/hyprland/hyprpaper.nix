{ host, ... }:

{
    services.hyprpaper = {
        enable = true;

        settings = if host == "uconsole" then {
            preload = [
                "/home/craft/.dotfiles/modules/hyprland/walls/uconsole.png"
            ];

            wallpaper = [
                ", /home/craft/.dotfiles/modules/hyprland/walls/uconsole.png"
            ];
        } else {};
    };
}
