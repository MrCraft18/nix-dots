{ configurationName, ... }:

{
    networking = {
        hostName = configurationName;
        networkmanager = {
            enable = true;
            settings.main.autoconnect-retries-default = 0;
        };
    };
}
