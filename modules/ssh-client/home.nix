{ pkgs, lib, config, host, ... }:

{
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

    sops.secrets."ssh_client_keys/${host}".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
}
