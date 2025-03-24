{ inputs, config, ... }:

{
    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops = {
        defaultSopsFile = ../../secrets.yaml;
        # vailidateSopsFiles = false;

        age = {
            # The path to the private ssh host key for this host so it can be used to decrypt the secrets encrypted with this host's public ssh host key.
            # sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519" ];
            sshKeyPaths = [ "/home/craft/.ssh/id_ed25519" ];
            
            # This is where the age private key will be after its generate from the ssh host private key.
            # keyFile = "/var/lib/sops-nix/key.txt";
            keyFile = "/home/craft/.config/sops/age/keys.txt";

            # Generate the private age private key from the ssh host private key if its not there.
            generateKey = true;
        };

        secrets = {
            hello = { };
        };
    };

    
}
