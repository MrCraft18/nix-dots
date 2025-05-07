{ pkgs, ... }:

{
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
}
