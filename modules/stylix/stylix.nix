{ config, pkgs, ... }:

{
    stylix = {
        enable = true;

        base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark-dark.yaml";
        
        image = pkgs.runCommand "image.png" { } ''
            COLOR=$(${pkgs.yq}/bin/yq -r .palette.base00 ${config.stylix.base16Scheme})
            ${pkgs.imagemagick}/bin/magick -size 1920x1080 xc:$COLOR $out
        '';

        # image = /home/craft/Downloads/kimi.jpg;
        # polarity = "dark";
    };

    home-manager.users.craft.stylix = {
        targets.waybar.addCss = false;
    };
}
