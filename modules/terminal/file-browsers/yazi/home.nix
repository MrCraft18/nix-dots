{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.fileBrowser;
in {
    config = lib.mkIf (cfg == "yazi") {
        programs.yazi = {
            enable = true;
            enableZshIntegration = true;

            keymap = {
                mgr.prepend_keymap = [
                    { on = [ "g" "s" ]; run = "cd /mnt/SSD"; desc = "Goto SSD"; }
                ];
            };
        };

        xdg.configFile."yazi/yazi.toml".source = pkgs.writeText "yazi.toml" ''
            [opener]
            proton = [ { run = 'WINEPREFIX=~/.umu-prefix PROTON_VERB=run umu-run "$@"', orphan = true, for = "unix", desc = "Run with Proton" } ]

            [open]
            prepend_rules = [
                { mime = "application/microsoft.portable-executable", use = [ "proton" ] }
            ]
        '';
    };
}
