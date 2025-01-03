{ config, pkgs, host, inputs, ... }:

{
# Home Manager needs a bit of information about you and the paths it should
# manage.
    home.username = "user";
    home.homeDirectory = "/home/user"; 

    home.stateVersion = "24.05"; # Please read the comment before changing.

# The home.packages option allows you to install Nix packages into your
# environment.
    home.packages = with pkgs; [
        yazi
        firefox
        kitty
        ripgrep
        gcc
        gh

        (retroarch.withCores (cores: with cores; [
            bsnes
        ]))

        # You can also create simple shell scripts directly inside your
        # configuration. For example, this adds a command 'my-hello' to your
        # environment:
        (pkgs.writeShellScriptBin "my-hello" ''
             echo "${host}"
        '')
    ]
    ++ [ inputs.zen-browser.packages.x86_64-linux.default ];

    imports = [
        ./modules/nvim
        ./modules/hyprland
        ./modules/kitty
    ];


# Home Manager is pretty good at managing dotfiles. The primary way to manage
# plain files is through 'home.file'.
    home.file = {
# # Building this configuration will create a copy of 'dotfiles/screenrc' in
# # the Nix store. Activating the configuration will then make '~/.screenrc' a
# # symlink to the Nix store copy.
# ".screenrc".source = dotfiles/screenrc;

# # You can also set the file content immediately.
# ".gradle/gradle.properties".text = ''
#   org.gradle.console=verbose
#   org.gradle.daemon.idletimeout=3600000
# '';
    };

# Home Manager can also manage your environment variables through
# 'home.sessionVariables'. These will be explicitly sourced when using a
# shell provided by Home Manager. If you don't want to manage your shell
# through Home Manager then you have to manually source 'hm-session-vars.sh'
# located at either
#
#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  /etc/profiles/per-user/user/etc/profile.d/hm-session-vars.sh
#
    home.sessionVariables = {
# EDITOR = "emacs";
    };

# Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
