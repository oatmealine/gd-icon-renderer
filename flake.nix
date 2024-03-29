
{
  description = "A Crystal Geometry Dash icon renderer library";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    crystal-flake.url = "github:manveru/crystal-flake";
  };

  outputs = { self, nixpkgs, flake-utils, crystal-flake }:
    (with flake-utils.lib; eachSystem defaultSystems) (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (crystal-flake.packages.${system}) crystal;
      in
      rec {
        packages = flake-utils.lib.flattenTree rec {
          gd-icon-renderer = pkgs.crystal.buildCrystalPackage {
            pname = "gd-icon-renderer";
            version = "0.2.0";

            src = ./.;

            format = "shards";
            lockFile = ./shard.lock;
            shardsFile = ./shards.nix;

            buildInputs = with pkgs; [ openssl pkg-config vips ] ++ [ crystal ];
            nativeBuildInputs = with pkgs; [ openssl pkg-config vips ] ++ [ crystal ];

            doInstallCheck = false;

            crystal = crystal;
          };
        };

        defaultPackage = packages.gd-icon-renderer;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            openssl
          ];

          nativeBuildInputs = with pkgs; [
            pkg-config
            crystal
            vips
          ];
        };
      });
}