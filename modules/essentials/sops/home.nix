{ config, lib, pkgs, inputs, configurationName, buildScope, androidProot ? null, ... }:

let
    sopsPackage =
            (pkgs.callPackage inputs.sops-nix { }).sops-install-secrets.overrideAttrs (_final: prev: {
                        unpackPhase = androidProot.androidUnpackPhase;

            goModules = prev.goModules.overrideAttrs (_: {
                            unpackPhase = androidProot.androidUnpackPhase;
                                        });

            configurePhase = ''
                            runHook preConfigure
                                            export GOCACHE=$TMPDIR/go-cache
                                                            export GOPATH="$TMPDIR/go"
                                                                            export GOPROXY=off
                                                                                            export GOSUMDB=off
                                                                                                            if [ -f "$NIX_CC_FOR_TARGET/nix-support/dynamic-linker" ]; then
                                                                                                                                export GO_LDSO=$(cat $NIX_CC_FOR_TARGET/nix-support/dynamic-linker)
                                                                                                                                                fi
                                                                                                                                                                cd "$modRoot"
                                                                                                                                                                                rm -rf vendor
                                                                                                                                                                                                mkdir vendor
                                                                                                                                                                                                                cp -r --no-preserve=mode,ownership "$goModules"/. vendor/
                                                                                                                                                                                                                                chmod -R u+w vendor
                                                                                                                                                                                                                                                runHook postConfigure
                                                                                                                                                                                                                                                            '';
                                                                                                                                                                                                                                                                    });
                                                                                                                                                                                                                                                                    in {
                                                                                                                                                                                                                                                                        home.packages = [ pkgs.sops ];

    sops = {
            defaultSopsFile = "${inputs.self}/configurations/${buildScope}/${configurationName}/secrets.yaml";
                    age = {
                                keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
                                            sshKeyPaths = lib.mkForce [];
                                                    };

        gnupg.sshKeyPaths = lib.mkForce [];
            } // lib.optionalAttrs (buildScope == "nix-on-droid") {
                    defaultSecretsMountPoint = "${config.home.homeDirectory}/.run/secrets.d";
                            package = sopsPackage;
                                };

    home.activation.sops-nix = lib.mkIf (buildScope == "nix-on-droid") (lib.mkForce ''
            export XDG_RUNTIME_DIR="${config.home.homeDirectory}/.run"

        mkdir -p "$XDG_RUNTIME_DIR"
                chmod 700 "$XDG_RUNTIME_DIR"

        ${builtins.elemAt config.systemd.user.services.sops-nix.Service.ExecStart 0}
            '');
            }
