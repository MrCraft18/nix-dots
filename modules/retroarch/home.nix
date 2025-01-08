{ pkgs, ... }:

{
    home.packages = with pkgs; [
        (retroarch.withCores (cores: with cores; [
            bsnes
        ]))
    ];
}
