{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    let
      inherit (self) outputs;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: { };
      flake = {
        nixosConfigurations = {
          newborn = {
            specialArgs = { inherit inputs outputs; };
            modules = [
              ./hosts/newborn/system/configuration.nix
            ];
          };
        };
      };
    };
}
