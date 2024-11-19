{
  description = "C Development Environments with LLVM 17 and GCC 14";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    forAllSystems = f:
      nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    formatter = forAllSystems ({pkgs}: pkgs.alejandra);

    packages = forAllSystems ({pkgs}: {
      default = pkgs.stdenv.mkDerivation {
        pname = "PNAME";
        version = "VERSION";
        src = ./.;
        nativeBuildInputs = with pkgs; [];
        buildInputs = with pkgs; [];
      };
      cross = pkgs.pkgsCross.gnu64.stdenv.mkDerivation {
        pname = "PNAME";
        version = "VERSION";
        src = ./.;
        nativeBuildInputs = with pkgs; [];
        buildInputs = with pkgs.pkgsCross.gnu64; [];
      };
    });

    devShells = forAllSystems ({pkgs}: let
      commonPackages = with pkgs;
        [
          ccache
          cmake
          cmocka
          meson
          ninja
          pkg-config
          python3
        ]
        ++ lib.optionals (!stdenv.isDarwin) [
          valgrind
          gdb
          gf
        ];

      llvmPackages = with pkgs.llvmPackages_17; [
        clang-tools_17
        lldb
        llvm
        bintools
      ];

      mkDevShell = {
        stdenv,
        extraPackages ? [],
      }:
        pkgs.mkShell {
          inherit stdenv;
          packages = commonPackages ++ extraPackages;
        };

      gccStdenv = pkgs.gcc14Stdenv;
      llvmStdenv = pkgs.llvmPackages_17.stdenv;
    in {
      default = mkDevShell {
        stdenv = gccStdenv;
      };
      gcc = mkDevShell {
        stdenv = gccStdenv;
      };
      gccMold = mkDevShell {
        stdenv = pkgs.stdenvAdapters.useMoldLinker gccStdenv;
        extraPackages = [pkgs.mold];
      };
      gccGold = mkDevShell {
        stdenv = pkgs.stdenvAdapters.useGoldLinker gccStdenv;
      };

      llvm = mkDevShell {
        stdenv = llvmStdenv;
        extraPackages = llvmPackages;
      };
      llvmMold = mkDevShell {
        stdenv = pkgs.stdenvAdapters.useMoldLinker llvmStdenv;
        extraPackages = llvmPackages ++ [pkgs.mold];
      };
      llvmGold = mkDevShell {
        stdenv = pkgs.stdenvAdapters.useGoldLinker llvmStdenv;
        extraPackages = llvmPackages;
      };

      gnu64Cross = pkgs.pkgsCross.gnu64.mkShell {
        nativeBuildInputs = with pkgs; [];
        buildInputs = with pkgs.pkgsCross.gnu64; [];
        packages = with pkgs; [
          pkgs.pkgsCross.gnu64.stdenv.cc
        ];
      };
    });
  };
}
