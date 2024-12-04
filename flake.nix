{
  description = "A collection of flake templates";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt-rfc-style);
      templates = rec {
        c = {
          path = ./c;
          description = "a Multi C Development Environment with LLVM and GCC and linkers";
        };

        go = {
          path = ./go;
          description = "A Golang Development Environment";
        };

        python = {
          path = ./python;
          description = "A Python 3.12 Development Environment";
        };

        rustFenix = {
          path = ./rust_fenix;
          description = "Rust Development Environment Via nix-community/fenix";
        };

        rustOxalica = {
          path = ./rust_oxalica;
          description = "Rust Development Environment Via oxalica/rust-overlay";
        };

        # Aliases
        rust = rustOxalica;
        rs = rust;
        py = python;
      };

      defaultTemplate = self.templates.c;
    };
}
