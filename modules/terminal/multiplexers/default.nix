{ lib, buildScope, ... }:

let
    directoryNames = builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.));
    paths = builtins.map (directory: ./. + "/${directory}") directoryNames;
in {
    imports = paths;

    options.moduleLoadout.terminal.multiplexer = lib.mkOption {
        type = lib.types.str;
        description = "Terminal multiplexer module selection";
    };
} // (if (buildScope == "nixos") then {
    config.home-manager.users.craft = { lib, ... }: {
        options.moduleLoadout.terminal.multiplexer = lib.mkOption {
            type = lib.types.str;
            description = "Terminal multiplexer module selection";
        };
    };
} else {})
