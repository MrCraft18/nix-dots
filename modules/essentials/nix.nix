{ lib, ... }:

{
    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
    };

    programs.nh = {
        enable = true;
        flake = "/home/craft/nix-dots";
    };

    nixpkgs.config.allowUnfree = true;
}
