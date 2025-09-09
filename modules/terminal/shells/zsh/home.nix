{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.shell;
in {
    config = lib.mkIf (cfg == "zsh") {
        programs.zsh = {
            enable = true;

            initContent = ''
                setopt PROMPT_SUBST
                PROMPT='%n@%m:%~/ > '
            '';

            shellAliases = {
                proton = "WINEPREFIX=~/.umu-prefix PROTON_VERB=run umu-run";
            };
        };
    };
}
