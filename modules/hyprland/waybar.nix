{ lib, host, ... }:

{
    programs.waybar = {
        enable = true;

        settings = {
            mainBar = {
                # Waybar at top layer
                # "layer": "top", 

                # Waybar position (top|bottom|left|right)
                # "position": "bottom", 

                # Waybar height (to be removed for auto height)
                height = 30;

                 # Waybar width
                # "width": 1280,

                # Gaps between modules (4px)
                spacing = if host == "uconsole" then 0 else 4; 

                # Choose the order of the modules
                modules-left = [
                    "hyprland/workspaces"
                ];
                modules-center = [
                    "hyprland/window"
                ];
                modules-right = if host == "desktop" then [
                    "pulseaudio"
                    "network"
                    "cpu"
                    "memory"
                    "clock"
                    "custom/power"
                ] else if host == "uconsole" then [
                    "pulseaudio"
                    "network"
                    "power-profiles-daemon"
                    "cpu"
                    "memory"
                    "temperature"
                    "battery"
                    "clock"
                ] else [
                    "mpd"
                    "pulseaudio"
                    "network"
                    "power-profiles-daemon"
                    "cpu"
                    "memory"
                    "temperature"
                    "backlight"
                    "battery"
                    "clock"
                    "custom/power"
                ];



                # Modules configuration
                # "sway/workspaces": {
                #     "disable-scroll": true,
                #     "all-outputs": true,
                #     "warp-on-scroll": false,
                #     "format": "{name}: {icon}",
                #     "format-icons": {
                #         "1": "",
                #         "2": "",
                #         "3": "",
                #         "4": "",
                #         "5": "",
                #         "urgent": "",
                #         "focused": "",
                #         "default": ""
                #     }
                # },
                clock = {
                    # "timezone": "America/New_York",
                    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                    format-alt = "{:%Y-%m-%d}";
                };
                cpu = {
                    format = "{usage}% ";
                    tooltip = false;
                };
                memory = {
                    format = "{}% ";
                };
                temperature = {
                    # "thermal-zone": 2,
                    critical-threshold = 80;
                    # "format-critical": "{temperatureC}°C {icon}",
                    format = "{temperatureC}°C {icon}";
                    format-icons = ["" "" ""];
                };
                backlight = {
                    # "device": "acpi_video1",
                    format = "{percent}% {icon}";
                    format-icons = ["" "" "" "" "" "" "" "" ""];
                };
                battery = {
                    states = {
                        # "good": 95,
                        warning = 30;
                        critical = 15;
                    };
                    format = "{capacity}% {icon}";
                    format-full = "{capacity}% {icon}";
                    format-charging = "{capacity}% ";
                    format-plugged = "{capacity}% ";
                    format-alt = "{time} {icon}";
                    # "format-good": "", # An empty format will hide the module
                    # "format-full": "",
                    format-icons = ["" "" "" "" ""];
                };
                power-profiles-daemon = {
                    format = "{icon}";
                        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
                        tooltip = true;
                    format-icons = {
                        default = "";
                        performance = "";
                        balanced = "";
                        power-saver = "";
                    };
                };
                network = {
                    # "interface": "wlp2*", # (Optional) To force the use of this interface
                    format-wifi = "{signalStrength}% ";
                    format-ethernet = "{ipaddr}/{cidr} ";
                    tooltip-format = "{ifname} via {gwaddr} ";
                    format-linked = "{ifname} (No IP) ";
                    format-disconnected = "Disconnected ⚠";
                    format-alt = "{ifname}: {ipaddr}/{cidr}";
                };
                pulseaudio = {
                    # "scroll-step": 1, # %, can be a float
                    format = "{volume}% {icon}";
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
                "custom/power" = {
                    format = "⏻ ";
                    tooltip = false;
                    menu = "on-click";
                    menu-file = "$HOME/.config/waybar/power_menu.xml"; # Menu file in resources folder
                    menu-actions = {
                        shutdown = "shutdown";
                        reboot = "reboot";
                        suspend = "systemctl suspend";
                        hibernate = "systemctl hibernate";
                    };
                };
            };
        };






        style = ''
            * {
                border: none;
                border-radius: 0;
                font-family: Roboto,'Font Awesome 5', 'SFNS Display',  Helvetica, Arial, sans-serif;
                font-size: 13px;
                min-height: 0;
            }

            window#waybar {
                background: rgba(43, 48, 59, 0.5);
                /* border-bottom: 3px solid rgba(100, 114, 125, 0.5); */
                color: #ffffff;
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

            #workspaces button.focused {
                background: #64727D;
                border-bottom: 3px solid #ffffff;
            }

            #workspaces button.urgent {
                background-color: #eb4d4b;
            }

            #mode {
                background: #64727D;
                border-bottom: 3px solid #ffffff;
            }

            #clock, #battery, #cpu, #memory, #temperature, #backlight, #network, #pulseaudio, #custom-media, #tray, #mode, #idle_inhibitor {
                padding: 0 10px;
                /* margin: 0 5px; */
            }

            #clock {
                background-color: #64727D;
            }

            #battery {
                background-color: #ffffff;
                color: #000000;
            }

            #battery.charging {
                color: #ffffff;
                background-color: #26A65B;
            }

            @keyframes blink {
                to {
                    background-color: #ffffff;
                    color: #000000;
                }
            }

            #battery.critical:not(.charging) {
                background: #f53c3c;
                color: #ffffff;
                animation-name: blink;
                animation-duration: 0.5s;
                animation-timing-function: linear;
                animation-iteration-count: infinite;
                animation-direction: alternate;
            }

            #cpu {
                background: #2ecc71;
                color: #000000;
            }

            #memory {
                background: #9b59b6;
            }

            #backlight {
                background: #90b1b1;
            }

            #network {
                background: #2980b9;
            }

            #network.disconnected {
                background: #f53c3c;
            }

            #pulseaudio {
                background: #f1c40f;
                color: #000000;
            }

            #pulseaudio.muted {
                background: #90b1b1;
                color: #2a5c45;
            }

            #custom-media {
                background: #66cc99;
                color: #2a5c45;
            }

            .custom-spotify {
                background: #66cc99;
            }

            .custom-vlc {
                background: #ffa000;
            }

            #temperature {
                background: #f0932b;
            }

            #temperature.critical {
                background: #eb4d4b;
            }

            #tray {
                background-color: #2980b9;
            }

            #idle_inhibitor {
                background-color: #2d3436;
            }

            #idle_inhibitor.activated {
                background-color: #ecf0f1;
                color: #2d3436;
            }
        '';
    };
}
