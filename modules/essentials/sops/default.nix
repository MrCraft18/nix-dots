{ buildScope, lib, ... }:

if buildScope == "nixos" then {
    imports = [ ./configuration.nix ];

    home-manager.users.craft.imports = lib.optional (builtins.pathExists ./home.nix) ./home.nix;
} else if buildScope == "home-manager" then {
    imports = lib.optional (builtins.pathExists ./home.nix) ./home.nix;
} else if buildScope == "nix-on-droid" then {
    home-manager.config.imports = lib.optional (builtins.pathExists ./home.nix) ./home.nix;
} else { }
