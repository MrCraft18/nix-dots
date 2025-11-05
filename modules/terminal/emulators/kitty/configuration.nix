{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.emulator;
in {
    config = lib.mkIf (cfg == "kitty") {
        programs.ssh.extraConfig = ''
            Host *
                SetEnv TERM=xterm-256color
        '';

        home-manager.users.craft.moduleLoadout.terminal.emulator = "kitty";
    };
}
