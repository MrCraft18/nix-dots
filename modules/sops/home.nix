{ pkgs, inputs, ... }:

{
    imports = [ inputs.sops-nix.homeManagerModules.sops ];

    sops = {
        defaultSopsFile = ../../secrets.yaml;
        age.keyFile = "/home/craft/.config/sops/age/keys.txt";

        secrets = import ./secrets.nix;
    };
}
