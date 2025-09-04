{ pkgs, ... }:

{
    imports = [
        ./sops/home.nix
    ];

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
