{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-23_11.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    hardware.url = "github:nixos/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    eww.url = "github:ralismark/eww/tray-3";
    eww.inputs.nixpkgs.follows = "nixpkgs";
    pointersay.url = "github:plzfgme/pointersay";
    pointersay.inputs.nixpkgs.follows = "nixpkgs";
    clitrans.url = "github:plzfgme/clitrans";
    clitrans.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-parts, ... }:
    let
      inherit (self) outputs;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: { };
      flake = {
        nixosModules = import ./modules/nixos;
        homeManagerModules = import ./modules/home-manager;

        nixosConfigurations = {
          newborn = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = [
              ./hosts/newborn/system/configuration.nix
            ];
          };
        };
        homeConfigurations = {
          "plzfgme@newborn" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = { inherit inputs outputs; };
            modules = [
              ./hosts/newborn/home/configuration.nix
            ];
          };
        };
      };
    };
}
