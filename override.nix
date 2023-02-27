{ pkgs ? import <nixpkgs> { }
, system ? builtins.currentSystem
}:
let
  nodePackages = import ./default.nix {
    inherit pkgs system;
    nodejs = pkgs."nodejs-18_x";
  };
in
nodePackages // {
  package = nodePackages.package.override {
    nativeBuildInputs =
      if pkgs.stdenv.isDarwin then [ pkgs.xcodebuild ] else [ ];

    # We don't have git inside the hermetic build
    preRebuild = ''
      echo "process.exit(0);" > parseGitCommit.js
    '';
  };
}
