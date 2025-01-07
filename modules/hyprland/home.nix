{ host, pkgs, inputs, ... }:

let
    hyprland = if host == "uconsole" then "uconsole-hyprland" else "hyprland";
in {
    home.packages = with pkgs; [
        hyprpaper
        yaru-theme
        wl-clipboard
        waybar
        wofi
    ];

    home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
    }; 

    wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;

        package = inputs.${hyprland}.packages.${pkgs.system}.hyprland;

        settings = {
            monitor = if host == "netbook" then [
                "DSI-1, preferred, auto, 1.6, transform, 3"
                "HDMI-A-1, preferred, auto, 1.6"
            ] else if host == "uconsole" then [
                "DSI-1, preferred, auto, 1.6, transform, 3"
            ] else if host == "desktop" then [
                # ADD TV BACK HERE
                "DP-3, preferred, 0x0, 1"
                "HDMI-A-1, preferred, 2560x0, 1"
                "DP-2, preferred, 5120x0, 1"
            ] else [
                ", preferred, auto, auto"
            ]; 

            exec-once = [
                "waybar"
                "hyprpaper"
            ];

            "$terminal" = "kitty";
            "$menu" = "wofi --show drun";            

            # env = [
            #     "XCURSOR_THEME,Yaru"                
            #     "XCURSOR_SIZE,24"
            # ];

            general = {
                "gaps_in" = if host == "uconsole" then 0 else 5;
                "gaps_out" = if host == "uconsole" then 0 else 20;

                "border_size" = if host == "uconsole" then 0 else 2;

                "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                "col.inactive_border" = "rgba(595959aa)";

                "resize_on_border" = true;

                "allow_tearing" = false;

                "layout" = "dwindle";
            };
            
            decoration = {
                rounding = if host == "uconsole" then 0 else 10;

                active_opacity = 1.0;
                inactive_opacity = 1.0;

                shadow = {
                    enabled = true;
                    range = 4;
                    render_power = 3;
                    color = "rgba(1a1a1aee)";
                };

                blur = {
                    enabled = true;
                    size = 3;
                    passes = 1;

                    vibrancy = 0.1696;
                };
            };

            animations =  {
                enabled = true;

                bezier = [
                    "easeOutQuint,0.23,1,0.32,1"
                    "easeInOutCubic,0.65,0.05,0.36,1"
                    "linear,0,0,1,1"
                    "almostLinear,0.5,0.5,0.75,1.0"
                    "quick,0.15,0,0.1,1"
                ];

                animation = [
                    "global, 1, 10, default"
                    "border, 1, 5.39, easeOutQuint"
                    "windows, 1, 4.79, easeOutQuint"
                    "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
                    "windowsOut, 1, 1.49, linear, popin 87%"
                    "fadeIn, 1, 1.73, almostLinear"
                    "fadeOut, 1, 1.46, almostLinear"
                    "fade, 1, 3.03, quick"
                    "layers, 1, 3.81, easeOutQuint"
                    "layersIn, 1, 4, easeOutQuint, fade"
                    "layersOut, 1, 1.5, linear, fade"
                    "fadeLayersIn, 1, 1.79, almostLinear"
                    "fadeLayersOut, 1, 1.39, almostLinear"
                    "workspaces, 1, 1.94, almostLinear, fade"
                    "workspacesIn, 1, 1.21, almostLinear, fade"
                    "workspacesOut, 1, 1.94, almostLinear, fade"
                ];
            };
            
            dwindle = {
                pseudotile = true;
                preserve_split =true;
            };
            
            master = {
                new_status = "master";
            };
            
            misc = {
                force_default_wallpaper = -1;
                disable_hyprland_logo = false;
            };

            input = {
                kb_layout = "us";
                # kb_variant =
                # kb_model =
                # kb_options =
                # kb_rules =

                follow_mouse = 1;

                sensitivity = if host == "netbook" then -0.25 else 0;

                touchpad = {
                    natural_scroll = false;
                };
            };

            gestures = {
                workspace_swipe = false;
            };

            "$mainMod" = "SUPER";

            bind = [
                "$mainMod, RETURN, exec, $terminal"
                "$mainMod, Q, killactive,"
                "$mainMod, M, exit,"
                "$mainMod, B, exec, zen"
                "$mainMod, E, exec, $fileManager"
                "$mainMod, V, togglefloating,"
                "$mainMod, R, exec, $menu"
                "$mainMod, P, pseudo," # dwindle
                "$mainMod, J, togglesplit," # dwindle
                "$mainMod, F, fullscreen,"

                # Move focus with mainMod + arrow keys
                "$mainMod, left, movefocus, l"
                "$mainMod, right, movefocus, r"
                "$mainMod, up, movefocus, u"
                "$mainMod, down, movefocus, d"

                # Switch workspaces with mainMod + [0-9]
                "$mainMod, 1, workspace, 1"
                "$mainMod, 2, workspace, 2"
                "$mainMod, 3, workspace, 3"
                "$mainMod, 4, workspace, 4"
                "$mainMod, 5, workspace, 5"
                "$mainMod, 6, workspace, 6"
                "$mainMod, 7, workspace, 7"
                "$mainMod, 8, workspace, 8"
                "$mainMod, 9, workspace, 9"
                "$mainMod, 0, workspace, 10"

                # Move active window to a workspace with mainMod + SHIFT + [0-9]
                "$mainMod SHIFT, 1, movetoworkspace, 1"
                "$mainMod SHIFT, 2, movetoworkspace, 2"
                "$mainMod SHIFT, 3, movetoworkspace, 3"
                "$mainMod SHIFT, 4, movetoworkspace, 4"
                "$mainMod SHIFT, 5, movetoworkspace, 5"
                "$mainMod SHIFT, 6, movetoworkspace, 6"
                "$mainMod SHIFT, 7, movetoworkspace, 7"
                "$mainMod SHIFT, 8, movetoworkspace, 8"
                "$mainMod SHIFT, 9, movetoworkspace, 9"
                "$mainMod SHIFT, 0, movetoworkspace, 10"

                # Example special workspace (scratchpad)
                "$mainMod, S, togglespecialworkspace, magic"
                "$mainMod SHIFT, S, movetoworkspace, special:magic"

                # Scroll through existing workspaces with mainMod + scroll
                "$mainMod, mouse_down, workspace, e+1"
                "$mainMod, mouse_up, workspace, e-1"
            ];

            bindm = [
                # Move/resize windows with mainMod + LMB/RMB and dragging
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
            ]; 

            bindel = [
                # Laptop multimedia keys for volume and LCD brightness
                ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
                ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
                ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
            ];
            
            bindl = [
                # Requires playerctl
                ", XF86AudioNext, exec, playerctl next"
                ", XF86AudioPause, exec, playerctl play-pause"
                ", XF86AudioPlay, exec, playerctl play-pause"
                ", XF86AudioPrev, exec, playerctl previous"
            ];

            windowrulev2 = [
                "suppressevent maximize, class:.*"
                "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
            ];
        };
   }; 
}
