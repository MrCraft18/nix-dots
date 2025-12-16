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
                    default = let
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
                            # Essential Pins
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

                            # Default Space Pins
                            "Credit Cards" = {
                                id = "d85a9026-1458-4db6-b115-346746bcc692";
                                workspace = spaces."Default".id;
                                isGroup = true;
                                editedTitle = true;
                                # isFolderCollapsed = false;
                            };

                            "Discover" = {
                                url = "https://portal.discover.com/web/customer/portal";
                                id = "1fe70bf4-2b4a-4fcd-a2d3-840b806a096e";
                                workspace = spaces."Default".id;
                                folderParentId = pins."Credit Cards".id;
                            };

                            "Citi Bank" = {
                                url = "https://online.citi.com/US/ag/dashboard/credit-card?accountId=16bb20ce-ad91-4ab2-8a70-89ab88bd10f6";
                                id = "4a4f476c-01d5-469c-866c-002c8ee87a45";
                                workspace = spaces."Default".id;
                                folderParentId = pins."Credit Cards".id;
                            };

                            "Amex" = {
                                url = "https://global.americanexpress.com/dashboard";
                                id = "37d612b8-d1a0-4e0f-8bb7-9edc030763fd";
                                workspace = spaces."Default".id;
                                folderParentId = pins."Credit Cards".id;
                            };

                            # Work Space Pins
                            "REventures" = {
                                url = "https://reventures.app";
                                id = "";
                                workspace = spaces."Work".id;
                            };

                            "Stripe Dashboard" = {
                                url = "https://dashboard.stripe.com";
                                id = "ceefbb2b-00f6-47ca-bc92-129111b05425";
                                workspace = spaces."Work".id;
                            };

                            "Spreadsheet" = {
                                url = "https://docs.google.com/spreadsheets/d/1DYM-Ptsa59jU3GXCke8ZUvc6qurO5HDar9KJ5LYsRdo";
                                id = "cfd2bf89-cacf-48bf-81f6-bcb552820b2f";
                                workspace = spaces."Work".id;
                            };

                            "MongoDB" = {
                                url = "https://cloud.mongodb.com/v2";
                                id = "08457688-f99f-480d-a127-dcdfad5f15a7";
                                workspace = spaces."Work".id;
                            };

                            "OpenAI" = {
                                url = "https://platform.openai.com/usage";
                                id = "09ecedf6-d6c4-4ab1-917b-e638e91ba686";
                                workspace = spaces."Work".id;
                            };

                            "Tailscale" = {
                                url = "https://login.tailscale.com/admin/machines";
                                id = "2a03e5d3-81ab-4f84-9fe8-dbc1e3e52b80";
                                workspace = spaces."Work".id;
                            };

                            "Facebook" = {
                                url = "https://www.facebook.com/";
                                id = "5e695298-3d42-412a-8b43-677ae9f9bc1e";
                                workspace = spaces."Work".id;
                            };

                            "GitHub" = {
                                url = "https://github.com/REventures/REventures";
                                id = "9fe85cea-38f6-47dd-a133-04909856b486";
                                workspace = spaces."Work".id;
                            };

                            "Railway" = {
                                url = "https://railway.com/project/c82a6c99-c94c-47e7-82a7-262fe8e52da7";
                                id = "060d7237-012e-48da-98f5-ee1af1cea71a";
                                workspace = spaces."Work".id;
                            };

                            # Linux Space Pins
                            "MyNixOS" = {
                                url = "https://mynixos.com";
                                id = "a894d07c-6eb4-4ec0-b06d-d18e3a727886";
                                workspace = spaces."Linux".id;
                            };

                            "NixOS Packages Search" = {
                                url = "https://search.nixos.org/packages";
                                id = "c7564100-1aa9-46b1-b0c4-ac3f85140489";
                                workspace = spaces."Linux".id;
                            };
                        };
                    in {
                        id = 0;
                        isDefault = true;
                        pinsForce = true;
                        inherit spaces pins;
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
