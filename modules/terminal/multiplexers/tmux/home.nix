{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.multiplexer;
in {
    config = lib.mkIf (cfg == "tmux") {
        programs.tmux = {
            enable = true;

            shortcut = "space";
            mouse = true;
            keyMode = "vi";
            clock24 = true;
            historyLimit = 10000;

            extraConfig = ''
                bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux config reloaded"
                bind-key -n M-h if-shell -F '#{pane_at_left}'  'previous-window' 'select-pane -L'
                bind-key -n M-l if-shell -F '#{pane_at_right}' 'next-window'     'select-pane -R'
            '';
        };

        programs.zsh.initContent = lib.mkAfter ''
            if [[ -o interactive ]] && [[ -z "$TMUX" ]] && command -v tmux >/dev/null 2>&1; then
                if tmux has-session -t default 2>/dev/null; then
                    exec tmux attach-session -t default
                else
                    exec tmux new-session -s default
                fi
            fi
        '';
    };
}
