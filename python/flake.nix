{
  description = "A Nix Dev Env for Python3";

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
    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs;
          [
            (python3.withPackages (pyPkgs: [
              # Pkgs here
            ]))
            ruff
            pyright
          ]
          ++ [
          ];
      };
    });
  };
}
