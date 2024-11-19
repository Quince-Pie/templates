{
  description = "Rust Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    fenix.url = "github:nix-community/fenix";
  };

  outputs = {
    self,
    nixpkgs,
    fenix,
  }: let
    forAllSystems = f:
      nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [fenix.overlays.default];
          };
        });
  in {
    formatter = forAllSystems ({pkgs}: pkgs.alejandra);
    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          (pkgs.fenix.stable.withComponents [
            "cargo"
            "clippy"
            "rustc"
            "rust-docs"
            "rust-src"
            "rustfmt"
          ])
          cargo-show-asm
          bacon
          cargo-nextest
          pkgs.fenix.rust-analyzer
        ];
      };
      cross = pkgs.mkShell {
        packages = with pkgs;
          [
            bacon
            cargo-show-asm
            cargo-nextest
            (pkgs.fenix.stable.withComponents [
              "cargo"
              "clippy"
              "rustc"
              "rust-docs"
              "rust-src"
              "rustfmt"
            ])
            pkgs.fenix.rust-analyzer
          ]
          ++ [targets.aarch64-unknown-linux-gnu.latest.rust-std];
        CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER = let
          inherit (pkgs.pkgsCross.aarch64-multiplatform.stdenv) cc;
        in "${cc}/bin/${cc.targetPrefix}cc";
      };
    });
  };
}
