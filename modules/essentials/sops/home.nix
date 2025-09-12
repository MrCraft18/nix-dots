{ config, lib, pkgs, inputs, configurationName, buildScope, ... }:

{
    home.packages = [ pkgs.sops ];

    sops = {
        defaultSopsFile = "${inputs.self}/configurations/${buildScope}/${configurationName}/secrets.yaml";
        age = {
            keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
            sshKeyPaths = lib.mkForce [];
        };
    };
}
