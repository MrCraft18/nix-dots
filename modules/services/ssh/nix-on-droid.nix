{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.services.ssh;
in {
    options.moduleLoadout.services.ssh = {
        enable = lib.mkEnableOption "ssh service module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.config.moduleLoadout.services.ssh.enable = true;
    };
}
