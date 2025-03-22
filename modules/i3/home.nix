{ pkgs, ... }:

{
    home.packages = with pkgs; [
        xorg.xinit
        # xorg.xorgserver
    ];

    xsession.windowManager.i3 = {
        enable = true;
    };
}
