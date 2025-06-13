{ ... }:

{
    programs.zsh = {
        enable = true;

        initContent = ''
            setopt PROMPT_SUBST
            PROMPT='%n@%m:%~/ > '
        '';
    };
}
