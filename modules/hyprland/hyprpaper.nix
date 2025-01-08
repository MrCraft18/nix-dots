{ host, ... }:

{
    services.hyprpaper = {
        enable = true;

        settings = if host == "uconsole" then {
            preload = [
                "./walls/uconsole.png"
            ];

            wallpaper = [
                ", ./walls/uconsole.png"
            ];
        } else {};
    };
}
