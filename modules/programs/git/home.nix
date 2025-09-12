{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.git;
in {
    options.moduleLoadout.programs.git = {
        enable = lib.mkEnableOption "git program module";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            gh
            lazygit
        ];

        programs.git = {
            enable = true;
            userName = "MrCraft18";
            userEmail = "mariocaden@gmail.com";

            extraConfig = {
                init.defaultBranch = "master";
                push.autoSetupRemote = "true";
                pull.rebase = "true";
                credential = {
                    "https://gist.github.com" = {
                        helper = [
                            ""
                            "!${pkgs.gh}/bin/gh auth git-credential"
                        ];
                    };

                    "https://github.com" = {
                        helper = [
                            ""
                            "!${pkgs.gh}/bin/gh auth git-credential"
                        ];
                    };
                };
            };
        };
    };
}
