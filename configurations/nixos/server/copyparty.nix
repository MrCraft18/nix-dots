{ config, pkgs, inputs, lib, ... }:

{
    imports = [ inputs.copyparty.nixosModules.default ];

    nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

    environment.systemPackages = [ pkgs.copyparty ];

    users.users.craft.extraGroups = [ "copyparty" ];

    sops.secrets."copyparty_craft_password" = {
        owner = config.services.copyparty.user;
    };

    systemd.services.copyparty.serviceConfig.UMask = lib.mkForce "0007";
    systemd.tmpfiles.settings.copyparty."/srv/copyparty".d.mode = lib.mkForce "2770";

    services.copyparty = {
        enable = true;
        # the user to run the service as
        user = "copyparty"; 

        # the group to run the service as
        group = "copyparty"; 

        # directly maps to values in the [global] section of the copyparty config.
        # see `copyparty --help` for available options
        settings = {
            i = "0.0.0.0";
            # use lists to set multiple values
            p = [ 3210 ];
            # use booleans to set binary flags
            no-reload = true;
            # using 'false' will do nothing and omit the value when generating a config
            ignored-flag = false;

            # stuff to make tailscale funnel work
            "xff-src" = "127.0.0.1/32";
            "xff-hdr" = "x-forwarded-for";
            rproxy = 1;
            "xf-proto" = "x-forwarded-proto";
            "xf-host" = "x-forwarded-host";
        };

        # create users
        accounts = {
            craft.passwordFile = config.sops.secrets."copyparty_craft_password".path;
        };

        # create a group
        # groups = {
        #     # users "ed" and "k" are part of the group g1
        #     g1 = [ "ed" "k" ];
        # };

        # create a volume
        volumes = {
            # create a volume at "/" (the webroot), which will
            "/" = {
                # share the contents of "/srv/copyparty"
                path = "/srv/copyparty";

                # see `copyparty --help-accounts` for available options
                access = {
                    rwmda = [ "craft" ];
                };

                # see `copyparty --help-flags` for available options
                flags = {
                    # "fk" enables filekeys (necessary for upget permission) (4 chars long)
                    fk = 4;
                    # scan for new files every 60sec
                    scan = 60;
                    # volflag "e2d" enables the uploads database
                    e2d = true;
                    # "d2t" disables multimedia parsers (in case the uploads are malicious)
                    d2t = true;
                    # skips hashing file contents if path matches *.iso
                    nohash = "\.iso$";
                };
            };
        };

        # you may increase the open file limit for the process
        # openFilesLimit = 8192;
    };
}
