{ pkgs, ... }:

{
    imports = [
        ./sops/home.nix
    ];

    programs.home-manager.enable = true;

    home.username = "craft";
    home.homeDirectory = "/home/craft";

    home.packages = with pkgs; [
        btop
        bat
        p7zip
        unrar
        fastfetch
        fzf
    ];
}
