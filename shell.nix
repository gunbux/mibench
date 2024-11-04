{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    gcc
    perf-tools
    python3
    lorem
    termcap
    ncurses
    linuxPackages.perf
    (python39Packages.buildPythonPackage rec {
      pname = "lorem";
      version = "0.1.1";

      src = pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-eF9BCaJB/CiR5ZcF6F0GX25tPtatkXUKjLVNTz5Z2TQ=";
      };
    })
  ];
}
