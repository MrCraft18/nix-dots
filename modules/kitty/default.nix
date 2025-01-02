{ host, pkgs, inputs, ... }:

{
    programs.kitty = {
        enable = true;

        settings = {
            enable_audio_bell = false;
            background_opacity = 0.6;
        };
    };
}
