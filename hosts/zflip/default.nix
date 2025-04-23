{ config, lib, pkgs, inputs, ... }:

{
  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim # or some other editor, e.g. nano or neovim
    openssh
    git
    gh
    zsh
    which
    curl
    iputils
    iproute2
    nettools
    glib.bin

    # Some common stuff that people expect to have
    #procps
    killall
    diffutils
    findutils
    utillinux
    #tzdata
    hostname
    man
    gnugrep
    #gnupg
    #gnused
    #gnutar
    #bzip2
    #gzip
    #xz
    #zip
    #unzip
  ] ++ [ inputs.lobster.packages."aarch64-linux".lobster ];

android-integration = {
    am.enable = true;
    termux-open.enable = true;
    termux-open-url.enable = true;
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
    xdg-open.enable = true;
  };

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  #time.timeZone = "Europe/Berlin";

  environment.etc."resolv.conf".text = lib.mkForce ''
    nameserver tail7438f7.ts.net
    nameserver 199.247.155.53
    nameserver 8.8.8.8
    nameserver 1.1.1.1
  '';
}
