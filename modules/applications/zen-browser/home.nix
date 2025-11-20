{ config, options, lib, pkgs, ... }:
let
    cfg = config.moduleLoadout.applications.zen-browser;
in {
    options.moduleLoadout.applications.zen-browser.enable = lib.mkEnableOption "zen-browser module";

    config = lib.mkIf cfg.enable (
        {
            programs.zen-browser = {
                enable = true;
                profileVersion = null;
                profiles = {
                    default = {
                        id = 0;
                        isDefault = true;

                        spaces = {
                            "Default" = {
                                id = "f33f42a8-371e-4cbb-92d0-bcf8a63d798a";
                                icon = "🍙";
                            };

                            "Work" = {
                                id = "52744f9b-fb26-4c3b-bfcf-8f22a4b3125b";
                                icon = "💼";
                            };

                            "Linux" = {
                                id = "2cb2315e-3229-458b-bac5-a8371d78e651";
                                icon = "💾";
                            };
                        };

                        pins = {
                            "ChatGPT" = {
                                url = "https://chatgpt.com";
                                id = "77b45578-94b8-41ff-9d1a-e47246cd2e39";
                                isEssential = true;
                            };

                            "Gmail" = {
                                url = "https://gmail.com";
                                id = "5ff39be4-c137-43e8-866c-833e96c2d178";
                                isEssential = true;
                            };

                            "Messages" = {
                                url = "https://messages.google.com/web/conversations";
                                id = "d1726059-cabf-4d4c-9fa2-d9c80cbfbaf1";
                                isEssential = true;
                            };

                            "YouTube" = {
                                url = "https://youtube.com";
                                id = "0ca1777e-f8f9-4e6f-aec9-9b004d91dd94";
                                isEssential = true;
                            };

                            "YouTube Music" = {
                                url = "https://music.youtube.com";
                                id = "e368b1f6-642b-4173-9c19-f1f708c2f13f";
                                isEssential = true;
                            };

                            "MyNixOS" = {
                                url = "https://mynixos.com";
                                id = "e368b1f6-642b-4173-9c19-f1f708c2f13f";
                                workspace = config.programs.zen-browser.profiles."default".spaces."Linux".id;
                            };
                        };

                        pinsForce = true;
                    };

                    wanky = {
                        id = 1;
                        isDefault = false;
                    };
                };
            };
        } // lib.optionalAttrs (lib.hasAttrByPath [ "stylix" ] options) {
            stylix.targets."zen-browser".profileNames = [ "default" ];
        }
    );
}
