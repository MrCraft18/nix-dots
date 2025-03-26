{ pkgs, config, ... }:

{
    sops.templates = {
        "ssh-config".content = ''
            Host desktop
                User craft
                HostName ${config.sops.placeholder."tunnel_service/domain"}
                Port ${config.sops.placeholder."tunnel_service/ports/desktop/ssh"}
                
            Host netbook
                User craft
                HostName ${config.sops.placeholder."tunnel_service/domain"}
                Port ${config.sops.placeholder."tunnel_service/ports/netbook/ssh"}

            Host uconsole
                User craft
                HostName ${config.sops.placeholder."tunnel_service/domain"}
                Port ${config.sops.placeholder."tunnel_service/ports/uconsole/ssh"}

            Host old-laptop
                User craft
                HostName ${config.sops.placeholder."tunnel_service/domain"}
                Port ${config.sops.placeholder."tunnel_service/ports/old-laptop/ssh"}

            Host chromebook-a
                User craft
                HostName ${config.sops.placeholder."tunnel_service/domain"}
                Port ${config.sops.placeholder."tunnel_service/ports/chromebook-a/ssh"}

            Host chromebook-b
                User craft
                HostName ${config.sops.placeholder."tunnel_service/domain"}
                Port ${config.sops.placeholder."tunnel_service/ports/chromebook-b/ssh"}
        '';
    };

    programs.ssh = {
        enable = true;
        includes = [
            config.sops.templates."ssh-config".path
        ];
    };
}
