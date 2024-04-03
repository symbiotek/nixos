{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: 
  let
    system = "x86_64-linux";
    overlay-unstable = final: prev: {
      # unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in
  {
    nixosConfigurations.hyperv = nixpkgs.lib.nixosSystem {
      specialArgs = inputs;
      modules = [
        ./hardware-configuration.nix
        ({ config, pkgs, ... }: { nixpkgs.overlays = [overlay-unstable ]; })
        ./configuration.nix
      ];
    };
  };
}

