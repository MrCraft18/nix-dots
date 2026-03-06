{ pkgs, lib, ... }:

{
    imports = [
        ./sops/home.nix
    ];

    programs.home-manager.enable = true;

    home.username = lib.mkDefault "craft";
    home.homeDirectory = lib.mkDefault "/home/craft";

    home.packages = with pkgs; [
        btop
        bat
        p7zip
        unrar
        fastfetch
        fzf
    ];
}
