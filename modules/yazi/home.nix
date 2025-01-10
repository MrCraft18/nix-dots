{ pkgs, ... }:

{
    programs.yazi = {
        enable = true;
        enableZshIntegration = true;
    };

    xdg.configFile."yazi/yazi.toml".source = pkgs.writeText "yazi.toml" ''
        [opener]
        wine = [ { run = "GAMEID=0 PROTON_VERB=run WINEPREFIX=/home/craft/.wine umu-run $@", orphan = true, for = "unix" } ]

        [open]
        prepend_rules = [
            { mime = "application/microsoft.portable-executable", use = [ "wine", "reveal" ] }
        ]
    '';
}
