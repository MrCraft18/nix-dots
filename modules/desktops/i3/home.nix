{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.desktop;
in {
    config = lib.mkIf (cfg == "i3") {
        home.packages = with pkgs; [
            dmenu
            yaru-theme
            xorg.xf86videointel
        ];

        home.file.".xinitrc".text = ''
            xrandr --output DSI-1 --rotate right --scale 1.8x1.8
            xrandr --output HDMI-1 --scale 2x2 --pos 3456x0

            export XCURSOR_SIZE=64
            export XCURSOR_THEME=Yaru

            xsetroot -cursor_name left_ptr

            exec i3
        '';

        xsession.enable = true;
        xsession.windowManager.i3 = {
            enable = true;
        };
    };
}
