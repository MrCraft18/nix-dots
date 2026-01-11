{ configurationName, inputs, config, lib, pkgs, ... }:

let
    cfg = config.moduleLoadout.programs.opencode;
in {
    options.moduleLoadout.programs.opencode = {
        enable = lib.mkEnableOption "opencode program module";
    };

    config = lib.mkIf cfg.enable {
        programs.opencode = {
            enable = true;
            package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;

            rules = ''
                  # External File Loading

                  CRITICAL: When you encounter a file reference (e.g., @rules/general.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.

                  Instructions:

                  - Do NOT preemptively load all references - use lazy loading based on actual need
                  - When loaded, treat content as mandatory instructions that override defaults
                  - Follow references recursively when needed
                  
                  # Self-Serve Code Discovery (No User Scavenger Hunts)

                  CRITICAL: Do NOT ask the user to direct you to specific files, folders, functions, or line ranges. Do NOT ask the user to paste code snippets "so you can help."

                  Instructions:

                  - You must locate relevant code yourself using the tools and context available (file search, symbol search, etc.)
                  - If you need a specific implementation detail, search for it directly by identifier names, related strings, call sites, or usage patterns.
                  - Prefer broad-to-narrow searching:
                      1) search for the feature/keyword
                      2) find call sites/usages
                      3) open the most likely source file(s)
                      4) trace imports/exports and control flow until the relevant logic is found
                  - Only ask the user for additional information if the code truly does not exist in the accessible context (e.g., missing repo access, unshared private file, tool limitations). In that case:
                      - Ask a single, minimal question that unblocks progress
                      - Provide exactly what you tried searching for and what you expected to find
                  - Never offload investigation to the user as a substitute for searching (no “can you point me to…”, “which file…”, “paste the function…”).

                  # Verify Documentation-Based Claims (Web Search Required)

                  CRITICAL: If you state or imply “what the docs say” or how something is *supposed* to work (APIs, flags, config, defaults, limits, workflows, recommended patterns, version-specific behavior, deprecations, compliance requirements, etc.), you must verify it via web search first.

                  Instructions:

                  - Before making definitive claims, use web search and prefer authoritative primary sources:
                      - Official documentation sites
                      - Official GitHub repos (README, docs, release notes, changelog)
                      - Vendor/provider docs and announcements
                      - Relevant standards bodies / RFCs (when applicable)
                  - Prefer the most recent, version-matched documentation. If version is unknown, explicitly say which version/date you verified against (or note that version is unclear).
                  - If sources conflict:
                      - Call out the disagreement
                      - Prefer primary/official sources and the newest applicable material
                  - If web search is unavailable or you cannot find a trustworthy source:
                      - Say you could not verify
                      - Avoid “it works like X” phrasing
                      - Provide a conditional recommendation and/or list assumptions
                      - Ask for the exact version or a docs link only as a last resort
                  - Do NOT rely on memory for details likely to change over time.
            '';
        };
    };
}
