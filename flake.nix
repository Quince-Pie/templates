{
  description = "A collection of flake templates";

  outputs = {self}: {
    templates = rec {
      rust = {
        path = ./rust_fenix;
        description = "Rust Development Environment";
      };

      c = {
        path = ./c;
        description = "a Multi C Development Environment with LLVM and GCC and linkers";
      };

      python = {
        path = ./python;
        description = "A Python 3.12 Development Environment";
      };

      # Aliases
      rs = rust;
      py = python;
    };

    defaultTemplate = self.templates.c;
  };
}
