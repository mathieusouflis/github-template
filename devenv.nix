{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.gh
    pkgs.terraform
    pkgs.jq
    pkgs.shellcheck
    pkgs.shfmt
  ];

  # https://devenv.sh/scripts/
  # Thin wrapper so the real CLI lives in a plain, dependency-free script
  # (bin/mat) that also runs standalone before this shell exists.
  scripts.mat.exec = ''
    exec "$DEVENV_ROOT/bin/mat" "$@"
  '';

  # https://devenv.sh/integrations/dotenv/
  dotenv.enable = true;

  # https://devenv.sh/basics/
  enterShell = ''
    clear
    echo "$(tput bold)✨ Welcome, $(whoami)!$(tput sgr0) — $(basename "$DEVENV_ROOT") dev shell"
    echo "   Tools: git · gh · terraform · jq · shellcheck · shfmt"
    echo "   First time here? Run: mat setup"
  '';

  # https://devenv.sh/binary-caching/
  cachix.enable = false;

  # See full reference at https://devenv.sh/reference/options/
}
