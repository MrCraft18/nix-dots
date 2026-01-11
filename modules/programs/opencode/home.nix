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
            '';
        };
    };
}
