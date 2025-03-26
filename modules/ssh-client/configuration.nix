{ pkgs, inputs, host, ... }:

{
    home-manager.users.craft.imports = [ ./home.nix ];
}
