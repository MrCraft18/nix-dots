{ config, lib, pkgs, inputs, configurationName, buildScope, ... }:

{
    imports = [ inputs.sops-nix.homeManagerModules.sops ];

    home.packages = [ pkgs.sops ];

    sops = {
        defaultSopsFile = ../../../configurations + "/${buildScope}/${configurationName}/secrets.yaml";
        age = {
            keyFile = "${config.home.homeDirectory}/.config/sops/age/key.txt";
            # sshKeyPaths = lib.mkOverride [];
        };
    };
}
