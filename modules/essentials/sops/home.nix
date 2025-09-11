{ config, lib, pkgs, inputs, configurationName, buildScope, ... }:

{
    home.packages = [ pkgs.sops ];

    sops = {
        defaultSopsFile = ../../../configurations + "/${buildScope}/${configurationName}/secrets.yaml";
        age = {
            keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
            sshKeyPaths = lib.mkForce [];
        };
    };
}
