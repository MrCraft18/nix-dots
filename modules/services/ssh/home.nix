{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.services.ssh;
in {
    options.moduleLoadout.services.ssh = {
        enable = lib.mkEnableOption "ssh service module";
    };

    config = lib.mkIf cfg.enable {
        sops.secrets."ssh/client".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };
}
