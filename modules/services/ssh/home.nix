{ configurationName, buildScope ? null, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.services.ssh;
        authorizedKeyFiles =
                lib.filter builtins.pathExists (
                            map (name: ../../../configurations/nixos + "/${name}/ssh_client.pub") (builtins.attrNames (builtins.readDir ../../../configurations/nixos)) ++
                                        map (name: ../../../configurations/nix-on-droid + "/${name}/ssh_client.pub") (builtins.attrNames (builtins.readDir ../../../configurations/nix-on-droid))
                                                );
                                                    authorizedKeys = lib.concatStringsSep "\n" (map builtins.readFile authorizedKeyFiles) + "\n";
                                                        authorizedKeysFile = pkgs.writeText "authorized_keys" authorizedKeys;
                                                        in {
                                                            options.moduleLoadout.services.ssh = {
                                                                    enable = lib.mkEnableOption "ssh service module";
                                                                        };

    config = lib.mkIf cfg.enable {
            sops.secrets."ssh/client".path = "${config.home.homeDirectory}/.ssh/id_ed25519";

        home.activation.writeSshAuthorizedKeys = lib.mkIf (buildScope == "nix-on-droid") (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                    mkdir -p "${config.home.homeDirectory}/.ssh"
                                chmod 700 "${config.home.homeDirectory}/.ssh"
                                            install -m 600 "${authorizedKeysFile}" "${config.home.homeDirectory}/.ssh/authorized_keys"
                                                    '');
                                                        };
                                                        }
