{ host, ... }:

{
    programs.kitty = {
        enable = true;

        themeFile = "OneDark-Pro";

        settings = {
            enable_audio_bell = false;
            confirm_os_window_close = 0;
        };
    };
}
