{ lib, ... }:

{
    programs.zellij = {
        enable = true;

        settings = {

        };
    };

    home.sessionVariables = {
        ZELLIJ_AUTO_ATTACH = "true";
        ZELLIJ_AUTO_EXIT = "true";
    };

    programs.zsh.initContent = lib.mkOrder 200 ''
        if [[ -z "$ZELLIJ" ]]; then
            if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
                zellij attach default -c
            else
                zellij
            fi

            if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
                exit
            fi
        fi
    '';
}
