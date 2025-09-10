{ pkgs, ... }:

{
    hardware.bluetooth.enable = true;

    environment.systemPackages = [ pkgs.bluez pkgs.bluetui ];
}
