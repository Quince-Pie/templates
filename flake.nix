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

      rust = {
        path = ./rust_fenix;
        description = "Rust Development Environment";
      };

      # Aliases
      rs = rust;
      py = python;
    };

    defaultTemplate = self.templates.c;
  };
}
