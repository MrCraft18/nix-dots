{ ... }:

{
    programs.zsh = {
        enable = true;

        initExtra = ''
            setopt PROMPT_SUBST
            PROMPT='%n@%m:%~/ > '
        '';
    };
}
