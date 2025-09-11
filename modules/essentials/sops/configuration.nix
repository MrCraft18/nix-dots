{ inputs, lib, config, configurationName, ... }:

{
    sops = {
        defaultSopsFile = ../../../configurations/nixos + "/${configurationName}/secrets.yaml";
        age = {
            keyFile = "/home/craft/.config/sops/age/keys.txt";
            sshKeyPaths = lib.mkForce [];
        };
    };
}
