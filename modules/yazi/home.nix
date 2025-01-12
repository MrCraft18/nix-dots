{ pkgs, ... }:

{
    programs.yazi = {
        enable = true;
        enableZshIntegration = true;

        keymap = {
            manager.prepend_keymap = [
                { on = [ "g" "s" ]; run = "cd /mnt/SSD"; desc = "Goto SSD"; }
            ];
        };
    };

    xdg.configFile."yazi/yazi.toml".source = pkgs.writeText "yazi.toml" ''
        [opener]
        wine = [ { run = 'wine "$@"', orphan = true, for = "unix", desc = "Run with Wine" } ]
        proton = [ { run = 'GAMEID=0 PROTON_VERB=run WINEPREFIX=~/.proton umu-run "$@" > /home/craft/thelog.txt 2>&1', orphan = true, for = "unix", desc = "Run with Proton" } ]

        [open]
        prepend_rules = [
            { mime = "application/microsoft.portable-executable", use = [ "wine", "proton" ] }
        ]
    '';
}
