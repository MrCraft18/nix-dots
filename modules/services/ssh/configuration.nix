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
            services.openssh = {
                        enable = true;
                                    settings = {
                                                    PasswordAuthentication = false;
                                                                };
                                                                        };

        sops.secrets."ssh/host/rsa".path = "/etc/ssh/ssh_host_rsa_key";
                sops.secrets."ssh/host/ed25519".path = "/etc/ssh/ssh_host_ed25519_key";
                        services.openssh.hostKeys = [
                                    {
                                                    path = "/etc/ssh/ssh_host_rsa_key";
                                                                    type = "rsa";
                                                                                }
                                                                                            {
                                                                                                            path = "/etc/ssh/ssh_host_ed25519_key";
                                                                                                                            type = "ed25519";
                                                                                                                                        }
                                                                                                                                                ];

        users.users.craft.openssh.authorizedKeys.keys =
                    map builtins.readFile authorizedKeyFiles;

        home-manager.users.craft.moduleLoadout.services.ssh.enable = true;
            };
            }
