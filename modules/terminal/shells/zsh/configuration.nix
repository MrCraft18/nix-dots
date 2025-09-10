{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.shell;
in {
    config = lib.mkIf (cfg == "zsh") {
        programs.zsh.enable = true;
        users.defaultUserShell = pkgs.zsh;

        home-manager.users.craft.moduleLoadout.terminal.shell = "zsh";
    };
}
