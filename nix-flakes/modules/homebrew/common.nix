# modules/homebrew/common.nix
# Homebrew configuration - reusable across macOS and Linux systems that support Homebrew
{ pkgs, stable, ... }:
{
  homebrew = {
    enable = true;
    brews = [
      "awscli"
      "aws-sso-util"
      "biome"
      "code2prompt"
      "colima"
      "docker"
      "docker-buildx"
      "docker-compose"
      "docker-credential-helper"
      "easy-rsa"
      "granted"
      "lazydocker"
      "llm"
      "mas"
      "mkcert"
      "terraform-docs"
      "ThreeDotsLabs/tap/tdl"
    ];
    casks = [
      "bifrost"
      "ghostty"
      "iina"
      "raycast"
      "session-manager-plugin"
      "the-unarchiver"
    ];
    taps = [
      "common-fate/granted"
      "ThreeDotsLabs/tap"
      "b3nk3/tap"
    ];
    masApps = {
      #  Install Mac App Store apps
      # use mas-cli to get their id
      # Need to be logged in and to have purchased the app before
      # "Yoink" = 457622435;
    };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
