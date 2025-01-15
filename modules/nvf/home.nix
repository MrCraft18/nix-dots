{ pkgs, inputs, ... }:

{
    imports = [
        inputs.nvf.homeManagerModules.nvf
    ];

    programs.nvf = {
        enable = true;
        settings = {
            vim = {
                options = {
                    smartindent = true;
                    autoindent = true;
                    expandtab =  true;
                    shiftwidth = 4;
                    tabstop = 4;
                    softtabstop = 4;
                    splitright = true; 
                    wrap = true;
                };

                # spellcheck = {
                #     enable = true;
                # };

                lazy.plugins = {
                    "onedarkpro.nvim" = {
                        package = pkgs.vimPlugins.onedarkpro-nvim;
                        setupModule = "onedarkpro";
                        setupOpts = { colors.onedark.bg = "#16181c"; };
                        after = ''vim.cmd("colorscheme onedark")'';
                    };

                    "oil.nvim" = {
                        package = pkgs.vimPlugins.oil-nvim;
                        setupModule = "oil";
                    };
                };

                languages = {
                    nix = {
                        enable = true;
                        lsp.enable = true;
                        treesitter.enable = true;
                    };
                };

                statusline.lualine = {
                    enable = true;
                    theme = "onedark";
                };

                dashboard.dashboard-nvim = {
                    enable = true;
                };
                
                telescope = {
                    enable = true;
                };

                # autopairs.nvim-autopairs.enable = true;

                autocomplete.nvim-cmp = {
                    enable = true;
                    sourcePlugins = [
                        "cmp-nvim-lsp"
                    ];
                };
            };
        };
    };
}
