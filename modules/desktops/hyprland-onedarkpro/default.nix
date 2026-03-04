{ buildScope, lib, ... }:

let
    importLogic = {
        nixos = { imports = [ ./configuration.nix ];  };
        home = { imports = lib.optional (builtins.pathExists ./home.nix) ./home.nix; };
        nix-on-droid = { imports = [ ./nix-on-droid.nix ]; home-manager.config.imports = lib.optional (builtins.pathExists ./home.nix) ./home.nix; };
    };
in importLogic."${buildScope}" or {}
