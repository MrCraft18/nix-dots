{ config, lib, pkgs, inputs, configurationName, buildScope, ... }:

{
    home.packages = [ pkgs.sops ];

    sops = {
        defaultSopsFile = ../../../configurations + "/${buildScope}/${configurationName}/secrets.yaml";
        age = {
            keyFile = "${config.home.homeDirectory}/.config/sops/age/key.txt";
            sshKeyPaths = lib.mkForce [];
        };
    };
}
