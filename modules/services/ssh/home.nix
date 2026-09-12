{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.services.ssh;
    authorizedKeyFiles =
        lib.filter builtins.pathExists (
            map (name: ../../../configurations/nixos + "/${name}/ssh_client.pub") (builtins.attrNames (builtins.readDir ../../../configurations/nixos)) ++
            map (name: ../../../configurations/nix-on-droid + "/${name}/ssh_client.pub") (builtins.attrNames (builtins.readDir ../../../configurations/nix-on-droid))
        );
in {
    options.moduleLoadout.services.ssh = {
        enable = lib.mkEnableOption "ssh service module";
    };

    config = lib.mkIf cfg.enable {
        sops.secrets."ssh/client".path = "${config.home.homeDirectory}/.ssh/id_ed25519";

        home.file.".ssh/authorized_keys".text =
            lib.concatStringsSep "\n" (map builtins.readFile authorizedKeyFiles) + "\n";
    };
}
