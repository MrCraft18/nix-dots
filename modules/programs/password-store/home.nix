{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.password-store;
in {
    options.moduleLoadout.programs.password-store = {
        enable = lib.mkEnableOption "password-store program module";
    };

    config = lib.mkIf cfg.enable {
        programs.gpg = {
            enable = true;
        };

        services.gpg-agent = {
            enable = true;
            pinentry.package = pkgs.pinentry-curses;
        };

        programs.password-store = {
            enable = true;
            settings = {
                PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
            };
        };

        # programs.browserpass.enable = true;
    };
}
