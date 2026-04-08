{ inputs, config, ... }:

{
    sops.secrets."craft_password" = {
        neededForUsers = true;
        sopsFile = "${inputs.self}/secrets.yaml";
    };

    users.mutableUsers = false;
    users.users.craft = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "video" "input" "minecraft" ];
        hashedPasswordFile = config.sops.secrets."craft_password".path;

        openssh.authorizedKeys.keyFiles =
            map (name: ../../configurations/nixos + "/${name}/ssh_client.pub") (builtins.attrNames (builtins.readDir ../../configurations/nixos)) ++
            map (name: ../../configurations/nix-on-droid + "/${name}/ssh_client.pub") (builtins.attrNames (builtins.readDir ../../configurations/nix-on-droid));
    };
}
