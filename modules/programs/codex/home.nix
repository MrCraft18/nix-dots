{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.codex;
in {
    options.moduleLoadout.programs.codex = {
        enable = lib.mkEnableOption "codex program module";
    };

    config = lib.mkIf cfg.enable {
        programs.codex = {
            enable = true;
            package = inputs.codex.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
                env = (old.env or {}) // {
                    CARGO_BUILD_JOBS = "1";
                    CARGO_PROFILE_RELEASE_LTO = "thin";
                    CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "16";
                };
            });
        };
    };
}
