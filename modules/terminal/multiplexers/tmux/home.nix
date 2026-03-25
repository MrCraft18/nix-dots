{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.terminal.multiplexer;
    tmuxPaneNav = pkgs.writeShellScriptBin "tmux-pane-nav" (builtins.readFile ./tmux-pane-nav.sh);
    tmuxRemote = pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tmux-remote";
        version = "unstable";
        rtpFilePath = "remote.tmux";
        src = pkgs.fetchFromGitHub {
            owner = "danyim";
            repo = "tmux-remote";
            rev = "8579e5a490822a833f2d8901a9c654827ecf1d53";
            hash = "sha256-xmVJfa5VyYyA9CBBYTfutBWJjDd31mZgHoqnQwpipWU=";
        };
    };
in {
    config = lib.mkIf (cfg == "tmux") {
        programs.tmux = {
            enable = true;

            shortcut = "space";
            mouse = true;
            keyMode = "vi";
            clock24 = true;
            escapeTime = 10;
            historyLimit = 10000;
            terminal = "tmux-256color";

            extraConfig = ''
                set -s extended-keys on
                set -s set-clipboard on
                set -as terminal-features ',xterm-kitty:clipboard,extkeys'

                bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux config reloaded"
                bind-key -n M-Left  if-shell -F '#{pane_at_left}'   'previous-window' 'select-pane -L'
                bind-key -n M-Right if-shell -F '#{pane_at_right}'  'next-window'     'select-pane -R'
                bind-key -n M-Down  run-shell '${tmuxPaneNav}/bin/tmux-pane-nav down'
                bind-key -n M-Up    run-shell '${tmuxPaneNav}/bin/tmux-pane-nav up'
                bind-key -n M-j run-shell '${tmuxPaneNav}/bin/tmux-pane-nav down'
                bind-key -n M-k run-shell '${tmuxPaneNav}/bin/tmux-pane-nav up'
                bind-key -n M-h if-shell -F '#{pane_at_left}'  'previous-window' 'select-pane -L'
                bind-key -n M-l if-shell -F '#{pane_at_right}' 'next-window'     'select-pane -R'
            '';

            plugins = [
                {
                    plugin = tmuxRemote;
                }
                {
                    plugin = pkgs.tmuxPlugins.resurrect;
                    extraConfig = ''
                        set -g @resurrect-capture-pane-contents 'on'
                        set -g @resurrect-processes 'ssh nvim opencode lazygit'
                    '';
                }
                {
                    plugin = pkgs.tmuxPlugins.continuum;
                    extraConfig = ''
                        set -g @continuum-restore 'on'
                    '';
                }
            ];
        };

        programs.zsh.initContent = lib.mkAfter ''
            if [[ -o interactive ]] && [[ -z "$TMUX" ]] && command -v tmux >/dev/null 2>&1; then
                tmux new-session -A -s default
            fi
        '';
    };
}
