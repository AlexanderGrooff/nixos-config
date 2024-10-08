{
  description = "Alex NixOS configs";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable = {url = "github:NixOS/nixpkgs/nixos-unstable";};

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      #url = "git+file:///home/alex/code/dotfiles";
      url = "github:AlexanderGrooff/dotfiles";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    unstable,
    ...
  } @ attrs: {
    nixosConfigurations.vm1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        # Include the results of the hardware scan.
        ./hosts/vm1

        ./system/btrfs.nix
        ./system/networking.nix
        ./system/system.nix
        ./system/users.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alex = {...}: {
            imports = [
              ./home/barebones.nix
              ./home/common.nix
              ./home/dev.nix
            ];
          };
          home-manager.extraSpecialArgs = attrs;
        }
      ];
    };
    nixosConfigurations.mu = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        # Include the results of the hardware scan.
        ./hosts/mu

        ./system/btrfs.nix
        ./system/desktop.nix
        ./system/networking.nix
        ./system/system.nix
        ./system/users.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alex = {...}: {
            imports = [
              ./home/barebones.nix
              ./home/common.nix
              ./home/dev.nix
              ./home/desktop.nix
            ];
          };
          home-manager.extraSpecialArgs = attrs;
        }
      ];
    };
  };
}
