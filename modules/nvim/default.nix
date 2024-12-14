{ config, pkgs, ... }:

{
    programs.neovim = {
        enable = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraLuaConfig = builtins.readFile ./lua/options.lua;

        extraPackages = with pkgs; [
            nil
            lua-language-server

            alejandra
            stylua
        ];

        plugins = with pkgs.vimPlugins; [

            {
                plugin = nvim-autopairs;
                type = "lua";
                config = "require('nvim-autopairs').setup({ map_cr = true })";
            }

            {
                plugin = comment-nvim;
                type = "lua";
                config = builtins.readFile ./lua/comment-nvim.lua;
            }

            {
                plugin = nvim-lspconfig;
                type = "lua";
                config = builtins.readFile ./lua/nvim-lspconfig.lua;
            }

            {
                plugin = nvim-cmp;
                type = "lua";
                config = builtins.readFile ./lua/nvim-cmp.lua;
            }

            cmp-nvim-lsp
            luasnip
            cmp_luasnip

            {
                plugin = none-ls-nvim;
                type = "lua";
                config = builtins.readFile ./lua/none-ls-nvim.lua;
            }

            {
                plugin = lualine-nvim;
                type = "lua";
                config = builtins.readFile ./lua/lualine-nvim.lua;
            }

            {
                plugin = onedarkpro-nvim;
                type = "lua";
                config = builtins.readFile ./lua/onedarkpro-nvim.lua;
            }

            {
                plugin = telescope-nvim;
                type = "lua";
                config = builtins.readFile ./lua/telescope-nvim.lua;
            }

            {
                plugin = neo-tree-nvim;
                type = "lua"; 
                config = builtins.readFile ./lua/neo-tree-nvim.lua;
            }

            nvim-web-devicons

            {
                plugin = nvim-treesitter; 
                type = "lua";
                config = ''
                    require('nvim-treesitter.configs').setup({
                        highlight = { enable = true },
                        indent = { enable = true },
                    })
                '';
            }
            nvim-treesitter.withAllGrammars
        ];
    };
}
