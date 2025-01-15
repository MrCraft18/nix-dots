{ pkgs, ... }:

{
    # home.packages = with pkgs; [
    #     (retroarch.withCores (cores: with cores; [
    #         bsnes
    #     ]))
    # ];


    home.packages = with pkgs; [
        (retroarch.withCores (cores: with cores; [
            bsnes
            flycast
        ] ++ (if host == "desktop" then with cores; [ 
                playcast
                blastem
        ] else [])))
    ];

}
