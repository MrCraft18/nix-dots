{ inputs, lib, config, configurationName, ... }:

{
    sops = {
        defaultSopsFile = "${inputs.self}/configurations/nixos/${configurationName}/secrets.yaml";
        age = {
            keyFile = "/home/craft/.config/sops/age/keys.txt";
            sshKeyPaths = lib.mkForce [];
        };
    };
}
