{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.services.ssh;
in {
    options.moduleLoadout.services.ssh = {
        enable = lib.mkEnableOption "ssh service module";
    };

    config = lib.mkIf cfg.enable {
        sops.templates = {
            "ssh-config".content = ''
                Host old-laptop
                    Port 3500

                Host chromebook-a
                    Port 3500

                Host chromebook-b
                    Port 3500
            '';
        };

        programs.ssh = {
            enable = true;
            includes = [
                config.sops.templates."ssh-config".path
            ];
        };

        sops.secrets."ssh/client".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };
}
