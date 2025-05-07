{ buildScope, lib, ... }:

if buildScope == "nixos" then {
    imports = [ ./configuration.nix ];

    home-manager.users.craft.imports = [ ./home.nix ];
} else if buildScope == "home-manager" then {
    imports = [ ./home.nix ];
} else if buildScope == "nix-on-droid" then {
    home-manager.config.imports = [ ./home.nix ];
} else { }
