{ pkgs, inputs, config, lib, host, ... }:

{
    home.packages = [ inputs.localxpose.packages.${pkgs.system}.default ];

    sops.templates = {
        "localxpose-config.yaml".content = 
            if host == "netbook" || host == "desktop" || host == "uconsole" then ''
            ssh:
                type: tcp
                region: us
                to: localhost:22
                reserved_endpoint: ${config.sops.placeholder."tunnel_service/domain"}:${config.sops.placeholder."tunnel_service/ports/${host}/ssh"}
        '' else ''
            ssh:
                type: tcp
                region: us
                to: localhost:3500
                reserved_endpoint: ${config.sops.placeholder."tunnel_service/domain"}:${config.sops.placeholder."tunnel_service/ports/${host}/ssh"}
            playwright:
                type: tcp
                region: us
                to: localhost:3501
                reserved_endpoint: ${config.sops.placeholder."tunnel_service/domain"}:${config.sops.placeholder."tunnel_service/ports/${host}/playwright"}
        '';
    };

    systemd.user.services.localxpose = 
        let
            localxposeEnv = pkgs.buildEnv {
                name = "localxpose-env";
                paths = [
                    pkgs.coreutils
                    inputs.localxpose.packages.${pkgs.system}.default
                ];
            };

            startScript = pkgs.writeShellScript "localxpose-start" ''
                set -e
                export PATH=${localxposeEnv}/bin:$PATH

                export ACCESS_TOKEN=$(cat ${config.sops.secrets."tunnel_service/authkey".path})

                exec loclx tunnel config -f ${config.sops.templates."localxpose-config.yaml".path}
            '';
        in {
        Unit = {
            Description = "localxpose agent";
            After = [ "sops-nix.service" ];
        };

        Service = {
            ExecStart = startScript;
            Restart = "always";
            RestartSec = 15;
        };

        Install = {
            WantedBy = [ "default.target" ];
        };
    };
}
