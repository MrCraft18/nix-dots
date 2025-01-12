{ host, ... }:

{
    programs.kitty = {
        enable = true;

        settings = {
            enable_audio_bell = false;
            background_opacity = 0.7;
            confirm_os_window_close = 0;
        };
    };
}
