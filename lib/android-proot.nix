{
    androidUnpackPhase = ''
        runHook preUnpack
        mkdir source
        cp -r --no-preserve=mode,ownership "$src"/. source/
        chmod -R u+w source
        cd source
        runHook postUnpack
    '';

    androidIntegrationFetchFromGitHubOverlay = final: prev: {
        fetchFromGitHub = args:
            if (args.repo or "") == "termux-am-socket" || (args.repo or "") == "termux-tools" then
                prev.fetchurl {
                    name = "${args.repo}-${args.rev}.tar.gz";
                    url = "https://github.com/${args.owner}/${args.repo}/archive/refs/tags/${args.rev}.tar.gz";
                    sha256 = if args.repo == "termux-am-socket" then
                        "sha256-UXUCPH/WdUkkUactBrdcdy8ldoW2n+EXInuuWl5vVJQ="
                    else
                        "sha256-HkCoxSxKIgUiSyy7dmJV4wSlFDKON6AilwdmaGMDLKo=";
                }
            else
                prev.fetchFromGitHub args;
    };
}
