{ inputs, configurationName, buildScope, ... }:

{
    home-manager = {
        extraSpecialArgs = { inherit inputs configurationName buildScope; };

        backupFileExtension = "hmBackup";
        useGlobalPkgs = true;
        useUserPackages = true;

        users.craft.imports = [ ./home.nix ];
    };
}
