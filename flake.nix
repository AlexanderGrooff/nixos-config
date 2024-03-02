{
  description = "Alex NixOS configs";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.vm2 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Include the results of the hardware scan.
        ./hosts/vm2/hardware-configuration.nix

        ./boot.nix
        ./desktop.nix
        ./networking.nix
        ./system.nix
        ./users.nix
      ];
    };
  };
}
