{ inputs, ... }:

{
    imports = [
        inputs.nvf.homeManagerModules.nvf
    ];

    programs.nvf = {
        enable = true;
        settings = {
            vim = {
                options = {
                    shiftwidth = 4;
                    tabstop = 4;
                    wrap = false;
                };

                lazy.plugins = {
                    
                };
            };
        };
    };
}
