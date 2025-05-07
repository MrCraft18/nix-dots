{ lib, host, ... }:

{
    programs.waybar = {
        enable = true;
        systemd.enable = true;

        settings = {
            mainBar = {
                # Waybar at top layer
                # "layer": "top", 

                # Waybar position (top|bottom|left|right)
                # "position": "bottom", 

                # Waybar height (to be removed for auto height)
                height = if host == "uconsole" then 0 else 30;

                 # Waybar width
                # "width": 1280,

                # Gaps between modules (4px)
                spacing = 4; 

                # Choose the order of the modules
                modules-left = if host == "uconsole" then [
                    "hyprland/workspaces"
                ] else [
                    "clock"
                ];
                modules-center = if host == "uconsole" then [

                ] else [
                    "hyprland/workspaces"
                ];
                modules-right = if host == "desktop" then [
                    "pulseaudio"
                    "network"
                    "cpu"
                    "memory"
                ] else if host == "uconsole" then [
                    "pulseaudio"
                    "network"
                    "cpu"
                    "memory"
                    "temperature"
                    "battery"
                    "clock"
                ] else [
                    "mpd"
                    "pulseaudio"
                    "network"
                    "cpu"
                    "memory"
                    "temperature"
                    "backlight"
                    "battery"
                ];



                # Modules configuration
                clock = {
                    interval = 1;
                    format = "{:%A, %B %d, %Y %H:%M:%S}";
                    on-click = "";
                    on-click-middle = "";
                    on-click-right = "";
                    on-scroll-up = "";
                    on-scroll-down = "";
                    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                };
                cpu = {
                    format = "CPU {usage}%";
                    tooltip = false;
                };
                memory = {
                    format = "RAM {}%";
                };
                temperature = {
                    # "thermal-zone": 2,
                    critical-threshold = 80;
                    # "format-critical": "{temperatureC}°C {icon}",
                    format = "TEMP {temperatureC}°";
                };
                backlight = {
                    # "device": "acpi_video1",
                    format = "LIGHT {percent}%";
                    format-icons = ["" "" "" "" "" "" "" "" ""];
                };
                battery = {
                    states = {
                        # "good": 95,
                        warning = 30;
                        critical = 15;
                    };
                    format = "BAT {capacity}%";
                    # format-full = "{capacity}% {icon}";
                    # format-charging = "{capacity}% ";
                    # format-plugged = "{capacity}% ";
                    # format-alt = "{time} {icon}";
                    # "format-good": "", # An empty format will hide the module
                    # "format-full": "",
                    # format-icons = ["" "" "" "" ""];
                };
                network = {
                    # "interface": "wlp2*", # (Optional) To force the use of this interface
                    format-wifi = "WIFI {signalStrength}%";
                    format-ethernet = "WIFI ETH";
                    tooltip-format = "{ifname} via {gwaddr}";
                    format-linked = "{ifname} (No IP)";
                    format-disconnected = "WIFI NONE";
                    format-alt = "{ifname}: {ipaddr}/{cidr}";
                };
                pulseaudio = {
                    # "scroll-step": 1, # %, can be a float
                    format = "SOUND {volume}%";
                    format-bluetooth = "{volume}% {icon} {format_source}";
                    format-bluetooth-muted = " {icon} {format_source}";
                    format-muted = " {format_source}";
                    format-source = "";
                    format-source-muted = "";
                    format-icons = {
                        headphone = "";
                            hands-free = "";
                            headset = "";
                            phone = "";
                            portable = "";
                            car = "";
                            default = ["" "" ""];
                    };
                    on-click = "pavucontrol";
                };
            };
        };



        style = lib.mkAfter ''
            * {
                border: none;
                border-radius: 0;
                min-height: 0;
            }

            window#waybar.hidden {
                opacity: 0.0;
            }

            /* https:#github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
            #workspaces button {
                padding: 0 5px;
                background: transparent;
                color: #ffffff;
                border-bottom: 3px solid transparent;
            }


            .modules-left #workspaces button {
                border-bottom: 3px solid transparent;
            }

            .modules-left #workspaces button.focused, .modules-left #workspaces button.active {
                border-bottom: 3px solid @base05;
            }
            .modules-center #workspaces button {
                border-bottom: 3px solid transparent;
            }
            .modules-center #workspaces button.focused, .modules-center #workspaces button.active {
                border-bottom: 3px solid @base05;
            }
            .modules-right #workspaces button {
                border-bottom: 3px solid transparent;
            }
            .modules-right #workspaces button.focused, .modules-right #workspaces button.active {
                border-bottom: 3px solid @base05;
            }

            #workspaces button.urgent {
                background-color: #eb4d4b;
            }

            #clock {
                color: @base05;
                border-bottom: 3px solid @base05;
            }

            #battery {
                color: @base0B;
                border-bottom: 3px solid @base0B;
            }

            #battery.charging {
                color: @base0A;
                border-bottom: 3px solid @base0A;
            }

            #battery.critical:not(.charging) {
                color: @base0F;
                border-bottom: 3px solid @base0F;
            }

            #cpu {
                color: @base0E;
                border-bottom: 3px solid @base0E;
            }

            #memory {
                color: @base09;
                border-bottom: 3px solid @base09;
            }

            #backlight {
                color: @base07;
                border-bottom: 3px solid @base07;
            }

            #network {
                color: @base0C;
                border-bottom: 3px solid @base0C;
            }

            #network.disconnected {
                color: @base0F;
                border-bottom: 3px solid @base0F;
            }

            #pulseaudio {
                color: @base0A;
                border-bottom: 3px solid @base0A;
            }

            #temperature {
                color: @base0D;
                border-bottom: 3px solid @base0D;
            }

            #temperature.critical {
                background: #eb4d4b;
            }
        '';
    };
}
