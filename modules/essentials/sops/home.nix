{ config, lib, pkgs, inputs, configurationName, buildScope, ... }:

{
    imports = [ inputs.sops-nix.homeManagerModules.sops ];

    home.packages = [ pkgs.sops ];

    sops = {
        defaultSopsFile = ../../../configurations + "/${buildScope}/${configurationName}/secrets.yaml";
        # age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    };
}
