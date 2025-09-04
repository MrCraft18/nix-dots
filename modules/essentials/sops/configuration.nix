{ inputs, lib, config, configurationName, ... }:

{
    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops = {
        defaultSopsFile = ../../../configurations/nixos + "/${configurationName}/secrets.yaml";
        # age.keyFile = "/home/craft/.config/sops/age/keys.txt";
    };
}
