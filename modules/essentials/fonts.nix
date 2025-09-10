{ pkgs, ... }:

{
    fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.source-han-sans
        pkgs.source-han-serif
    ]; 
}
