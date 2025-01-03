{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-24_11.url = "github:NixOS/nixpkgs/nixos-24.11";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    hardware.url = "github:nixos/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-eww.url = "github:NixOS/nixpkgs/81736c5f250fd815a68f1bd999a7de4710884b85";
    eww.url = "github:elkowar/eww";
    eww.inputs.nixpkgs.follows = "nixpkgs-eww";
    wl_translation_window.url = "github:plzfgme/wl_translation_window";
    wl_translation_window.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = inputs@{ self, nixpkgs, nur, home-manager, flake-parts, ... }:
    let
      inherit (self) outputs;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = {
          vm = inputs.nixos-generators.nixosGenerate {
            system = system;
            specialArgs = { inherit pkgs inputs outputs; diskSize = 40 * 1024; };
            modules = [
              ./hosts/vm/system/configuration.nix
            ];
            format = "qcow";
          };
        };
      };
      flake = {
        nixosModules = import ./modules/nixos;
        homeManagerModules = import ./modules/home-manager;

        nixosConfigurations = {
          newborn = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = [
              nur.modules.nixos.default
              ./hosts/newborn/system/configuration.nix
            ];
          };

          skull = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = [
              nur.modules.nixos.default
              ./hosts/skull/system/configuration.nix
            ];
          };

          dragon = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = [
              nur.modules.nixos.default
              ./hosts/dragon/system/configuration.nix
            ];
          };

          dragon-wsl = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = [
              inputs.nixos-wsl.nixosModules.default
              nur.modules.nixos.default
              ./hosts/dragon-wsl/system/configuration.nix
            ];
          };

          vm = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs outputs; };
            modules = [
              nur.modules.nixos.default
              ./hosts/vm/system/configuration.nix
            ];
          };
        };
        homeConfigurations = {
          "plzfgme@newborn" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = { inherit inputs outputs; };
            modules = [
              nur.hmModules.nur.default
              ./hosts/newborn/home/configuration.nix
            ];
          };

          "plzfgme@skull" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = { inherit inputs outputs; };
            modules = [
              nur.hmModules.nur.default
              ./hosts/skull/home/configuration.nix
            ];
          };

          "plzfgme@dragon" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = { inherit inputs outputs; };
            modules = [
              nur.hmModules.nur.default
              ./hosts/dragon/home/configuration.nix
            ];
          };

          "plzfgme@vm" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = { inherit inputs outputs; };
            modules = [
              nur.hmModules.nur.default
              ./hosts/vm/home/configuration.nix
            ];
          };
        };
      };
    };
}
