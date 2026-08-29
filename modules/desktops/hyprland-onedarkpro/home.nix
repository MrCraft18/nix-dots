{ configurationName, buildScope, inputs, config, lib, options, pkgs, ... }:

let
    cfg = config.moduleLoadout.desktop;
    hyprland = if configurationName == "uconsole" then "uconsole-hyprland" else "hyprland";
    lua = lib.generators.mkLuaInline;
    bind = key: dispatcher: { _args = [ key (lua dispatcher) ]; };
    bindOpt = key: dispatcher: opts: { _args = [ key (lua dispatcher) opts ]; };
    execBind = key: command: bind key "hl.dsp.exec_cmd(${builtins.toJSON command})";
    dispatchBind = key: dispatcher: bind key "hl.dsp.${dispatcher}";
    windowBind = key: dispatcher: bind key "hl.dsp.window.${dispatcher}";
    focusBind = key: direction: bind key "hl.dsp.focus({ direction = ${builtins.toJSON direction} })";
    workspaceBind = key: workspace: bind key "hl.dsp.focus({ workspace = ${builtins.toJSON workspace} })";
    moveWorkspaceBind = key: workspace: bind key "hl.dsp.window.move({ workspace = ${builtins.toJSON workspace} })";
    hyprgrass = inputs.hyprgrass.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        postPatch = (if old ? postPatch then old.postPatch else "") + ''
            substituteInPlace src/TouchVisualizer.cpp \
                --replace-fail '2 * PI' '2 * 3.14159265358979323846' \
                --replace-fail 'g_pCompositor->scheduleFrameForMonitor(mon);' 'mon->scheduleFrame();' \
                --replace-fail 'g_pCompositor->scheduleFrameForMonitor(Desktop::focusState()->monitor());' 'Desktop::focusState()->monitor()->scheduleFrame();'

            substituteInPlace src/GestureManager.cpp \
                --replace-fail '<hyprland/src/helpers/Monitor.hpp>' '<hyprland/src/output/Monitor.hpp>' \
                --replace-fail '<hyprland/src/managers/SeatManager.hpp>' '<hyprland/src/managers/SeatManager.hpp>
#include <hyprland/src/state/MonitorState.hpp>' \
                --replace-fail 'g_pCompositor->getMonitorFromName(!ev.device->m_boundOutput.empty() ? ev.device->m_boundOutput : "")' 'State::monitorState()->query().name(!ev.device->m_boundOutput.empty() ? ev.device->m_boundOutput : "").run()'
        '';
    });
in {
    imports = [
        ./waybar.nix
    ];

    config = lib.mkIf (cfg == "hyprland-onedarkpro") ({
        home.packages = with pkgs; [
            hyprpaper
            phinger-cursors
            wl-clipboard
            rofi
            brightnessctl
        ] ++ (if configurationName == "netbook" then [
            inputs.iio-hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default
            wvkbd
        ] else []);

        home.pointerCursor = {
            name = "phinger-cursors-dark";
            package = pkgs.phinger-cursors;
            size = 24;
            gtk.enable = true;
            x11.enable = true;
        };

        home.sessionVariables = {
            NIXOS_OZONE_WL = "1";
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        }; 

        home.activation.cleanupHyprland = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            rm -f ~/.config/hypr/hyprland.conf.hmBackup
        '';

        wayland.windowManager.hyprland = {
            enable = true;
            configType = if configurationName == "uconsole" then "hyprlang" else "lua";
            systemd.enable = true;
            xwayland.enable = true;

            package = null;
            portalPackage = null;

            plugins = if configurationName == "desktop" then [] else [
                hyprgrass
            ];

            settings = {
                mainMod = { _var = "SUPER"; };
                terminal = { _var = "kitty"; };
                menu = { _var = "rofi -show drun"; };

                monitor = if configurationName == "netbook" then [
                    { output = "DSI-1"; mode = "preferred"; position = "auto"; scale = 1.6; transform = 3; }
                    { output = "HDMI-A-1"; mode = "preferred"; position = "auto"; scale = 1.6; }
                ] else if configurationName == "uconsole" then [
                    "DSI-1, preferred, auto, 1.6, transform, 3"
                ] else if configurationName == "desktop" then [
                    { output = "DP-3"; mode = "preferred"; position = "0x-740"; scale = 1; transform = 1; }
                    { output = "DP-2"; mode = "preferred"; position = "1080x0"; scale = 1; }
                    { output = "DP-1"; mode = "preferred"; position = "3640x0"; scale = 1; }
                ] else if configurationName == "panasonic" then [
                    { output = "LVDS-1"; mode = "preferred"; position = "auto"; scale = 1; }
                ] else if configurationName == "thinkpad" then [
                    { output = "eDP-1"; mode = "preferred"; position = "auto"; scale = 1.2; }
                    { output = "DP-1"; mode = "preferred"; position = "auto"; scale = 1; }
                ] else [
                    { output = ""; mode = "preferred"; position = "auto"; scale = "auto"; }
                ];

                env = [
                    { _args = [ "NIXOS_OZONE_WL" "1" ]; }
                    { _args = [ "ELECTRON_OZONE_PLATFORM_HINT" "wayland" ]; }
                ];

                config = {
                    general = {
                        gaps_in = if configurationName == "uconsole" then 0 else 2;
                        gaps_out = if configurationName == "uconsole" then 0 else 8;
                        border_size = if configurationName == "uconsole" then 0 else 2;
                        resize_on_border = true;
                        allow_tearing = false;
                        layout = "dwindle";
                    };

                    decoration = {
                        rounding = 0;
                        active_opacity = 1.0;
                        inactive_opacity = 1.0;
                        shadow = {
                            enabled = true;
                            range = 4;
                            render_power = 3;
                        };
                        blur = {
                            enabled = true;
                            size = 3;
                            passes = 1;
                            vibrancy = 0.1696;
                        };
                    };

                    animations.enabled = true;

                    dwindle.preserve_split = true;

                    master.new_status = "master";

                    misc = {
                        enable_swallow = true;
                        swallow_regex = "^(kitty)$";
                        force_default_wallpaper = -1;
                    };

                    input = {
                        kb_layout = if configurationName == "panasonic" then "jp" else "us";
                        kb_model = lib.mkIf (configurationName == "panasonic") "jp106";
                        follow_mouse = 1;
                        sensitivity = if configurationName == "netbook" then -0.25 else 0;
                    };

                    cursor = lib.mkIf (configurationName == "netbook") {
                        no_hardware_cursors = true;
                    };
                } // lib.optionalAttrs (configurationName != "desktop") {
                    plugin.touch_gestures.hyprgrass-bind = [
                        ", edge:d:u, exec, kill -34 $(ps -C wvkbd-mobintl -o pid=)"
                    ];
                };

                bind = [
                    (bind (lua "mainMod .. ' + RETURN'") "hl.dsp.exec_cmd(terminal)")
                    (windowBind (lua "mainMod .. ' + Q'") "close()")
                    (dispatchBind (lua "mainMod .. ' + M'") "exit()")
                    (execBind (lua "mainMod .. ' + B'") "zen-beta")
                    (execBind (lua "mainMod .. ' + W'") "zen-beta -P wanky")
                    (execBind (lua "mainMod .. ' + E'") "$fileManager")
                    (windowBind (lua "mainMod .. ' + V'") "float()")
                    (bind (lua "mainMod .. ' + R'") "hl.dsp.exec_cmd('NIXOS_OZONE_WL=1 ELECTRON_OZONE_PLATFORM_HINT=wayland ' .. menu)")
                    (windowBind (lua "mainMod .. ' + P'") "pseudo()")
                    (dispatchBind (lua "mainMod .. ' + S'") "layout('togglesplit')")
                    (windowBind (lua "mainMod .. ' + F'") "fullscreen()")

                    (focusBind (lua "mainMod .. ' + left'") "left")
                    (focusBind (lua "mainMod .. ' + right'") "right")
                    (focusBind (lua "mainMod .. ' + up'") "up")
                    (focusBind (lua "mainMod .. ' + down'") "down")
                    (focusBind (lua "mainMod .. ' + h'") "left")
                    (focusBind (lua "mainMod .. ' + l'") "right")
                    (focusBind (lua "mainMod .. ' + k'") "up")
                    (focusBind (lua "mainMod .. ' + j'") "down")

                    (windowBind (lua "mainMod .. ' + SHIFT + left'") "move({ direction = 'left' })")
                    (windowBind (lua "mainMod .. ' + SHIFT + right'") "move({ direction = 'right' })")
                    (windowBind (lua "mainMod .. ' + SHIFT + up'") "move({ direction = 'up' })")
                    (windowBind (lua "mainMod .. ' + SHIFT + down'") "move({ direction = 'down' })")
                    (windowBind (lua "mainMod .. ' + SHIFT + h'") "move({ direction = 'left' })")
                    (windowBind (lua "mainMod .. ' + SHIFT + l'") "move({ direction = 'right' })")
                    (windowBind (lua "mainMod .. ' + SHIFT + k'") "move({ direction = 'up' })")
                    (windowBind (lua "mainMod .. ' + SHIFT + j'") "move({ direction = 'down' })")

                    (windowBind (lua "mainMod .. ' + ALT + right'") "resize({ x = 10, y = 0, relative = true })")
                    (windowBind (lua "mainMod .. ' + ALT + left'") "resize({ x = -10, y = 0, relative = true })")
                    (windowBind (lua "mainMod .. ' + ALT + up'") "resize({ x = 0, y = -10, relative = true })")
                    (windowBind (lua "mainMod .. ' + ALT + down'") "resize({ x = 0, y = 10, relative = true })")
                    (windowBind (lua "mainMod .. ' + ALT + l'") "resize({ x = 10, y = 0, relative = true })")
                    (windowBind (lua "mainMod .. ' + ALT + h'") "resize({ x = -10, y = 0, relative = true })")
                    (windowBind (lua "mainMod .. ' + ALT + k'") "resize({ x = 0, y = -10, relative = true })")
                    (windowBind (lua "mainMod .. ' + ALT + j'") "resize({ x = 0, y = 10, relative = true })")

                    (windowBind "ALT + P" "pin()")

                    (workspaceBind (lua "mainMod .. ' + 1'") "1")
                    (workspaceBind (lua "mainMod .. ' + 2'") "2")
                    (workspaceBind (lua "mainMod .. ' + 3'") "3")
                    (workspaceBind (lua "mainMod .. ' + 4'") "4")
                    (workspaceBind (lua "mainMod .. ' + 5'") "5")
                    (workspaceBind (lua "mainMod .. ' + 6'") "6")
                    (workspaceBind (lua "mainMod .. ' + 7'") "7")
                    (workspaceBind (lua "mainMod .. ' + 8'") "8")
                    (workspaceBind (lua "mainMod .. ' + 9'") "9")
                    (workspaceBind (lua "mainMod .. ' + 0'") "10")

                    (moveWorkspaceBind (lua "mainMod .. ' + SHIFT + 1'") "1")
                    (moveWorkspaceBind (lua "mainMod .. ' + SHIFT + 2'") "2")
                    (moveWorkspaceBind (lua "mainMod .. ' + SHIFT + 3'") "3")
                    (moveWorkspaceBind (lua "mainMod .. ' + SHIFT + 4'") "4")
                    (moveWorkspaceBind (lua "mainMod .. ' + SHIFT + 5'") "5")
                    (moveWorkspaceBind (lua "mainMod .. ' + SHIFT + 6'") "6")
                    (moveWorkspaceBind (lua "mainMod .. ' + SHIFT + 7'") "7")
                    (moveWorkspaceBind (lua "mainMod .. ' + SHIFT + 8'") "8")
                    (moveWorkspaceBind (lua "mainMod .. ' + SHIFT + 9'") "9")
                    (moveWorkspaceBind (lua "mainMod .. ' + SHIFT + 0'") "10")

                    (workspaceBind (lua "mainMod .. ' + mouse_down'") "e+1")
                    (workspaceBind (lua "mainMod .. ' + mouse_up'") "e-1")

                    (windowBind (lua "mainMod .. ' + mouse:272'") "drag('move')")
                    (windowBind (lua "mainMod .. ' + mouse:273'") "drag('resize')")

                    (bindOpt "XF86AudioRaiseVolume" ("hl.dsp.exec_cmd(" + builtins.toJSON "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+" + ")") { locked = true; repeating = true; })
                    (bindOpt "XF86AudioLowerVolume" ("hl.dsp.exec_cmd(" + builtins.toJSON "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-" + ")") { locked = true; repeating = true; })
                    (bindOpt "XF86AudioMute" ("hl.dsp.exec_cmd(" + builtins.toJSON "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" + ")") { locked = true; })
                    (bindOpt "XF86AudioMicMute" ("hl.dsp.exec_cmd(" + builtins.toJSON "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" + ")") { locked = true; })
                    (bindOpt "XF86MonBrightnessUp" ("hl.dsp.exec_cmd(" + builtins.toJSON "brightnessctl s 5%+" + ")") { locked = true; repeating = true; })
                    (bindOpt "XF86MonBrightnessDown" ("hl.dsp.exec_cmd(" + builtins.toJSON "brightnessctl s 5%-" + ")") { locked = true; repeating = true; })
                    (bindOpt "XF86AudioNext" ("hl.dsp.exec_cmd(" + builtins.toJSON "playerctl next" + ")") { locked = true; })
                    (bindOpt "XF86AudioPause" ("hl.dsp.exec_cmd(" + builtins.toJSON "playerctl play-pause" + ")") { locked = true; })
                    (bindOpt "XF86AudioPlay" ("hl.dsp.exec_cmd(" + builtins.toJSON "playerctl play-pause" + ")") { locked = true; })
                    (bindOpt "XF86AudioPrev" ("hl.dsp.exec_cmd(" + builtins.toJSON "playerctl previous" + ")") { locked = true; })
                ];

                window_rule = [
                    { match.class = ".*"; suppress_event = "maximize"; }
                    { match = { class = "^$"; title = "^$"; xwayland = true; float = true; fullscreen = false; pin = false; }; no_focus = true; }
                    { match.class = "^wlvncc$"; fullscreen_state = "2 2"; suppress_event = "fullscreen"; }
                    { match.class = "^steam_app_.*"; fullscreen_state = "2 1"; suppress_event = "fullscreen"; }
                ];

                workspace_rule = lib.optionals (configurationName == "desktop") [
                    { workspace = "1"; monitor = "DP-2"; }
                    { workspace = "2"; monitor = "DP-2"; }
                    { workspace = "3"; monitor = "DP-2"; }
                    { workspace = "4"; monitor = "DP-2"; }
                    { workspace = "5"; monitor = "DP-2"; }
                ];
            };

            extraConfig = ''
                hl.on("hyprland.start", function()
                  hl.exec_cmd("hyprpaper")
            '' + (if configurationName == "netbook" then ''
                  hl.exec_cmd("iio-hyprland DSI-1")
                  hl.exec_cmd("wvkbd-mobintl -L 230 -H 350 --hidden")
            '' else "") + ''
                end)
            '';
        }; 
    } // lib.optionalAttrs (lib.hasAttrByPath [ "stylix" ] options) {
        stylix = lib.mkMerge [
            (lib.mkIf (buildScope == "home") {
                enable = true;
                base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark-dark.yaml";
                image = config.lib.stylix.pixel "base00";
            })

            {
                targets.waybar.addCss = false;

                enableReleaseChecks = false;
            }
        ];
    });
}
