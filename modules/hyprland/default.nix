{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        yaru-theme
        wl-clipboard
        waybar
    ];

   wayland.windowManager.hyprland = {
        enable = true;

        settings = {
            debug = {    
                disable_logs = false;
            };

            monitor = [
                "DSI-1, preferred, auto, 1.6, transform, 3"
                "HDMI-A-1, preferred, auto, 1.6"
            ]; 

            exec-once = [
                "waybar"
            ];

            "$terminal" = "kitty";
            "$menu" = "wofi --show drun";            

            env = [
                "XCURSOR_THEME,Yaru"                
                "XCURSOR_SIZE,24"
            ];

            general = {
                "gaps_in" = 5;
                "gaps_out" = 20;

                "border_size" = 2;

                "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                "col.inactive_border" = "rgba(595959aa)";

                "resize_on_border" = false;

                "allow_tearing" = false;

                "layout" = "dwindle";
            };
            
            decoration = {
                rounding = 10;

                active_opacity = 1.0;
                inactive_opacity = 1.0;

                drop_shadow = true;
                shadow_range = 4;
                shadow_render_power = 3;
                "col.shadow" = "rgba(1a1a1aee)";

                blur = {
                    enabled = true;
                    size = 3;
                    passes = 1;

                    vibrancy = 0.1696;
                };
            };

            animations =  {
                enabled = true;


                bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
                
                animation = [    
                    "windows, 1, 7, myBezier"
                    "windowsOut, 1, 7, default, popin 80%"
                    "border, 1, 10, default"
                    "borderangle, 1, 8, default"
                    "fade, 1, 7, default"
                    "workspaces, 1, 6, default"
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

                sensitivity = -0.25;

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

            windowrulev2 = "suppressevent maximize, class:.*"; # You'll probably like this.
        };
   }; 
}
