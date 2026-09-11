{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.services.ssh;
in {
    options.moduleLoadout.services.ssh = {
        enable = lib.mkEnableOption "ssh service module";
    };

    config = lib.mkIf cfg.enable {
        home-manager.config = {
            moduleLoadout.services.ssh.enable = true;

            programs.zsh.initContent = lib.mkAfter ''
                if ! ${pkgs.psmisc}/bin/killall -0 sshd >/dev/null 2>&1; then
                    ${pkgs.openssh}/bin/sshd -f "$HOME/.sshd/sshd_config" >/dev/null 2>&1 || true
                fi
            '';
        };
    };
}
