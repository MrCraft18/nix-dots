{ pkgs, lib, ... }:

{
	programs.home-manager.enable = true;

	home.username = lib.mkDefault "craft";
	home.homeDirectory = lib.mkDefault "/home/craft"; 

	home.stateVersion = "24.05";

	home.packages = with pkgs; [
# You can also create simple shell scripts directly inside your
# configuration. For example, this adds a command 'my-hello' to your
# environment:
		(pkgs.writeShellScriptBin "my-hello" ''
		 echo "${host}"
		 '')

			(pkgs.writeShellScriptBin "gen-age-keys" ''
			 mkdir -p ~/.config/sops/age && nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt && nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
			 '')

	] ++ [ 
# inputs.localxpose.packages.${pkgs.system}.default
	];

	programs.git = {
		enable = true;
		userName = "MrCraft18";
		userEmail = "mariocaden@gmail.com";

		extraConfig = {
			init.defaultBranch = "master";
			credential = {
				"https://gist.github.com" = {
					helper = [
						""
							"!${pkgs.gh}/bin/gh auth git-credential"
					];
				};

				"https://github.com" = {
					helper = [
						""
							"!${pkgs.gh}/bin/gh auth git-credential"
					];
				};
			};
		};
	};

	programs.gpg = {
		enable = true;
	};

	home.sessionVariables = {
		BEMENU_OPTS = "--center --width-factor 0.5 --margin 20 --line-height 30 --fn 'JetBrains Mono 12' --ff '#ffffff' --fb '#1d1f21'";
	};

	services.gpg-agent = {
		enable = true;
		pinentryPackage = pkgs.pinentry-rofi;
	};

	programs.password-store = {
		enable = true;
		settings = {
			PASSWORD_STORE_DIR = "/home/craft/.password-store";
		};
	};

	programs.browserpass.enable = true;
}


