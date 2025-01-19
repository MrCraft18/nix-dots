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
                    wrap = false;
                    cursorline = true;
                };

                lsp = {
                    # formatOnSave = true;

                    lspkind.enable = true;

                    # lspsaga.enable = true;

                    #This is kind of in the way when I type out a function
                    lspSignature.enable = true;

                    lsplines.enable = true;
                };

                languages = {
                    enableLSP = true;
                    enableTreesitter = true;

                    nix.enable = true;
                    ts.enable = true;
                    python.enable = true;
                };

                # spellcheck = {
                #     enable = true;
                # };

                visuals = {
                    nvim-scrollbar.enable = true;

                    nvim-web-devicons.enable = true;

                    # I want this but it does nohing if enabled
                    # nvim-cursorline.enable = true;

                    # I want this but it does nohing if enabled
                    # cinnamon-nvim.enable = true;

                    # This is just boojie or whatever
                    # fidget-nvim.enable = true;

                    #This seems useful I guess?
                    # highlight-undo.enable = true;

                    # Need To Configure but its good
                    indent-blankline.enable = true;

                    # Fun
                    cellular-automaton.enable = true;
                };

                statusline.lualine = {
                    enable = true;
                    theme = "onedark";
                };

                tabline.nvimBufferline.enable = true;

                treesitter.context = {
                    enable = true;
                    setupOpts = {
                        max_lines = 6;
                        mode = "topline";
                    };
                }; 

                dashboard = {
                    dashboard-nvim.enable = true;
                    # alpha.enable = true;
                };

                # session = {
                #     nvim-session-manager.enable = true;
                # };

                utility = {
                    surround.enable = true;
                    motion = {
                        precognition = {
                            enable = true;
                            setupOpts = {
                                startVisible = false;
                            };
                        };
                    };
                };

                telescope = {
                    enable = true;
                };

                autopairs.nvim-autopairs.enable = true;

                autocomplete.nvim-cmp = {
                    enable = true;
                };

                binds = {
                    whichKey.enable = true;
                    cheatsheet.enable = true;
                };

                ui = {
                    #This isnt doing anything
                    breadcrumbs  = {
                        enable = true;
                        navbuddy.enable = true;
                    };
                    
                };

                presence.neocord.enable = true;

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
                        keys = [ { mode = [ "n" ]; key = "<Leader>o"; action = ":Oil<CR>"; noremap = true; silent = true; desc = "Open Oil"; } ];
                    };

                    "toggleterm.nvim" = {
                        package = pkgs.vimPlugins.toggleterm-nvim;
                        setupModule = "toggleterm";
                        keys = [
                            { mode = [ "n" ]; key = "<Leader>t"; action = ":ToggleTerm<CR>"; noremap = true; silent = true; desc = "Toggle Terminal"; }

                            { mode = [ "n" ]; key = "<Leader>Tf"; action = ":ToggleTerm direction=float<CR>"; noremap = true; silent = true; desc = "Toggle Float Terminal"; }
                            { mode = [ "n" ]; key = "<Leader>Tt"; action = ":ToggleTerm direction=tab<CR>"; noremap = true; silent = true; desc = "Toggle Tab Terminal"; }
                            { mode = [ "n" ]; key = "<Leader>Th"; action = ":ToggleTerm direction=horizontal<CR>"; noremap = true; silent = true; desc = "Toggle Horizontal Terminal"; }
                            { mode = [ "n" ]; key = "<Leader>Tv"; action = ":ToggleTerm direction=vertical<CR>"; noremap = true; silent = true; desc = "Toggle Vertical Terminal"; }
                        ];
                        after = ''
                            function _G.set_terminal_keymaps()
                                local opts = {buffer = 0}
                                vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
                                vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
                            end 

                            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
                        '';
                    };
                };

                keymaps = [
                    { mode = [ "n" ]; key = "<Leader>n"; action = ":Navbuddy<CR>"; noremap = true; silent = true; desc = "Open NavBuddy"; }
                ];
            };
        };
    };
}
