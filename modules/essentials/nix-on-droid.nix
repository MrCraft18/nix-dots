{ pkgs, ... }:

{
    environment.packages = with pkgs; [
        coreutils
        gzip
        ripgrep
        dnsutils
        glibc.bin
        getent
        gnused
        gawk
        file
        less
        procps
        psmisc
    ];

    home-manager = {
        config = {
            imports = [ ./home.nix ];
        };
    };
}
