{
  description = "A collection of flake templates";

  outputs = {self}: {
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
