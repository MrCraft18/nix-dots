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

            settings = {
                user = {
                    name = "MrCraft18";
                    email = "mariocaden@gmail.com";
                };

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
