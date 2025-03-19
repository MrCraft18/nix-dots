{ pkgs, ... }:

{
    home.packages = with pkgs; [
        xorg.xinit
        xorg.xorgserver
    ];

    xsession = {
        enable = true;
        windowManager.i3 = {
            enable = true;
        };
    };
}
