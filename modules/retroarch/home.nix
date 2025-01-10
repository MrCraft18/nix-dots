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
            blastem
            flycast
        ] ++ (if host == "desktop" then with cores; [ 
                playcast
        ] else [])))
    ];

}
