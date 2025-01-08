{ buildScope, ... }:

{
    imports = if buildScope == "home-manager" then [ ./home.nix ] else [ ./configuration.nix ];
}
