{ pkgs, ... }:

{
    programs.yazi = {
        enable = true;
        enableZshIntegration = true;
    };

    xdg.configFile."yazi/yazi.toml".source = pkgs.writeText "yazi.toml" ''
        [opener]
        wine = [ { run = "wine $0 > /home/craft/the-log.txt 2>&1", orphan = true, for = "unix" } ]

        [open]
        prepend_rules = [
            { mime = "application/microsoft.portable-executable", use = [ "wine", "reveal" ] }
        ]
    '';
}
