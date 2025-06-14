{
  description = "Jupyter Book: Generalization over Enumeration - Mathematical Ideas for Python Testing";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pythonEnv = pkgs.python311.withPackages (ps: [
          ps.jupyter-book
          ps.hypothesis
          ps.jupyterlab
          ps.matplotlib
          ps.numpy
          ps.pandas
        ]);
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              pythonEnv
              pkgs.git
              pkgs.gnumake
            ];
            
            shellHook = ''
              echo "Jupyter Book development environment ready (HTML only)!"
              echo "Run 'jupyter-book build .' to build the book"
              echo "Run 'jupyter-lab' for interactive editing"
            '';
          };
          
          pdf = pkgs.mkShell {
            buildInputs = [
              pythonEnv
              pkgs.git
              pkgs.gnumake
              pkgs.texlive.combined.scheme-full
            ];
            
            shellHook = ''
              echo "Jupyter Book development environment ready (with PDF support)!"
              echo "Run 'jupyter-book build .' to build the book"
              echo "Run 'jupyter-book build . --builder pdflatex' for PDF output"
              echo "Run 'jupyter-lab' for interactive editing"
            '';
          };
        };
      }
    );
}
