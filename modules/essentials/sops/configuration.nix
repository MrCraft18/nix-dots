{ inputs, lib, config, configurationName, ... }:

{
    sops = {
        defaultSopsFile = ../../../configurations/nixos + "/${configurationName}/secrets.yaml";
        age = {
            keyFile = "/home/craft/.config/sops/age/key.txt";
            sshKeyPaths = lib.mkForce [];
        };
    };
}
