{ config, pkgs, lib, ... }:

{
	programs.home-manager.enable = true;

	home.username = lib.mkDefault "craft";
	home.homeDirectory = lib.mkDefault "/home/craft"; 

	home.stateVersion = "24.05";

	home.packages = with pkgs; [
		(pkgs.writeShellScriptBin "my-hello" ''
             echo "${config.home.homeDirectory}"
		 '')

        (pkgs.writeShellScriptBin "gen-age-keys" ''
             mkdir -p ~/.config/sops/age && nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt && nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
        '')
	];
}


