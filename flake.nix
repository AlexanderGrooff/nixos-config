{
  description = "Alex NixOS configs";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable = {url = "github:NixOS/nixpkgs/nixos-unstable";};

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astronvim = {
      url = "github:AstroNvim/AstroNvim/v3.44.0";
      flake = false;
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
    nixosConfigurations.vm2 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        # Include the results of the hardware scan.
        ./hosts/vm2

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
