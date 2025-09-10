{ buildScope, lib, ... }:

let
    importLogic = {
        nixos = { imports = [ ./configuration.nix ]; home-manager.users.craft.imports = lib.optional (builtins.pathExists ./home.nix) ./home.nix; };
        home = { imports = [ ./home.nix ]; };
        nix-on-droid = { imports = [ ./nix-on-droid.nix ]; home-manager.config.imports = [ ./home.nix ]; };
    };
in importLogic."${buildScope}" or {}
