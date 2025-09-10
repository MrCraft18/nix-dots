{ configurationName, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.applications.retroarch;
in {
    options.moduleLoadout.applications.retroarch = {
        enable = lib.mkEnableOption "retroarch module";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            (retroarch.withCores (cores: with cores; [
                bsnes
                flycast
            ] ++ (if configurationName == "desktop" then with cores; [ 
                    flycast 
                    blastem
            ] else [])))
        ];
    };
}
