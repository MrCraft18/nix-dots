{ config, pkgs, ... }:

{
    stylix = {
        enable = true;

        base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark-dark.yaml";
        
        image = config.lib.stylix.pixel "base00";
    };
}
