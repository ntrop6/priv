{
  description = "otoka's NixOS system (channels -> flake, + noctalia v5)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    niri-float-sticky.url = "github:probeldev/niri-float-sticky";
    nixcord.url = "github:4evy/nixcord";

zen-browser = {
  url = "github:0xc000022070/zen-browser-flake";
};

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia";
  };

  outputs = { self, nixpkgs, home-manager, noctalia, niri-float-sticky, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix

        noctalia.nixosModules.default

        home-manager.nixosModules.home-manager

        {
          programs.noctalia.enable = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = {
            inherit inputs;
          };

          home-manager.users.otoka = import ./home.nix;
        }
      ];
    };
  };
}
