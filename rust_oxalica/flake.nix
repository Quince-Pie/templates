{
  description = "Rust Development Environment Using oxalica/rust-overlay";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    rust-overlay,
  }: let
    forAllSystems = f:
      nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [(import rust-overlay)];
          };
        });
  in {
    formatter = forAllSystems ({pkgs}: pkgs.alejandra);
    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          (rust-bin.stable.latest.default.override {
            extensions = [
              "clippy"
              "rust-docs"
              "rust-src"
              "rustfmt"
              "rust-analyzer"
            ];
          })
          cargo-show-asm
          bacon
          cargo-nextest
        ];
      };
      nightly = pkgs.mkShell {
        packages = with pkgs; [
          (rust-bin.selectLatestNightlyWith (toolchain:
            toolchain.default.override {
              extensions = [
                "clippy"
                "rust-docs"
                "rust-src"
                "rustfmt"
                "rust-analyzer"
              ];
            }))
          cargo-show-asm
          bacon
          cargo-nextest
        ];
      };
      crossAArch64 = pkgs.mkShell {
        packages = with pkgs; [
          bacon
          cargo-show-asm
          cargo-nextest
          (rust-bin.stable.latest.default.override {
            extensions = [
              "clippy"
              "rust-docs"
              "rust-src"
              "rustfmt"
              "rust-analyzer"
            ];
            targets = ["aarch64-unknown-linux-gnu"];
          })
        ];
        CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER = let
          inherit (pkgs.pkgsCross.aarch64-multiplatform.stdenv) cc;
        in "${cc}/bin/${cc.targetPrefix}cc";
      };
    });
  };
}
