{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.emulator;
in {
    config = lib.mkIf (cfg == "kitty") {
        programs.kitty = {
            enable = true;

            settings = {
                enable_audio_bell = false;
                confirm_os_window_close = 0;

                font_size = 10;
            };
        };
    };
}
