{
  description = "A Neovim Shell for rust development";

  inputs = {

    nixpkgs = {
	   url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    neovim = {
      url = "github:neovim/neovim/stable?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay.url = "github:oxalica/rust-overlay";

    flake-utils.url  = "github:numtide/flake-utils";

  };

  outputs = { self, nixpkgs, neovim, rust-overlay, flake-utils, }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlayFlakeInputs = prev: final: {
          neovim = neovim.packages.${system}.neovim;
        };

        overlayNeovim = prev: final: {
          customNeovim = import ./packages/nvimConfig.nix {
            pkgs = final;
          };
        };

        overlays = [ overlayFlakeInputs overlayNeovim (import rust-overlay) ];

        pkgs = import nixpkgs {
          inherit system overlays;
        };

      in
      {
        devShells.default = with pkgs; mkShell {
          buildInputs = [
            openssl
            rust-analyzer
            pkg-config
            rust-bin.beta.latest.default
            customNeovim
            alsa-lib
            udev
            vulkan-tools
            vulkan-headers
            vulkan-loader
            vulkan-validation-layers
            lld
            wayland
            libxkbcommon
          ];

          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${
              pkgs.lib.makeLibraryPath [
                udev
                alsaLib
                vulkan-loader
                libxkbcommon
              ]
            }"
          '';

          RUST_SRC_PATH = rustPlatform.rustLibSrc;
        };
        packages.default = pkgs.customNeovim;
        packages.defaultPackage = pkgs.customNeovim;

        apps.default = {
          type = "app";
          program = "${pkgs.customNeovim}/bin/nvim";
        };
      }
    );
}

