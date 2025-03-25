{ pkgs, inputs, config, lib, host, ... }:

{
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
            startScript = pkgs.writeShellScript "localxpose-start" ''
                set -e

                ACCESS_TOKEN=$(cat ${config.sops.secrets."tunnel_service/authkey".path})

                exec ${inputs.localxpose.packages.${pkgs.system}.default}/bin/loclx tunnel config \
                  -f ${config.sops.templates."localxpose-config.yaml".path}
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
