{ pkgs, ... }:

{
    fonts.packages = [
        pkgs.corefonts
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.source-han-sans
        pkgs.source-han-serif
    ]; 
}
