# modules/homebrew/common.nix
# Homebrew configuration - reusable across macOS and Linux systems that support Homebrew
{ pkgs, stable, ... }:
{
  homebrew = {
    enable = true;
    brews = [
      "agent-browser"
      "awscli"
      "aws-sso-util"
      "biome"
      "code2prompt"
      "docker"
      "docker-buildx"
      "docker-compose"
      "docker-credential-helper"
      "easy-rsa"
      "fastmod"
      "granted"
      "protobuf"
      "lazydocker"
      "llm"
      "mas"
      "mise"
      "mkcert"
      "ollama"
      "open-code-review"
      "anomalyco/tap/opencode"
      "python"
      "terraform-docs"
      "ThreeDotsLabs/tap/tdl"
      "uv"
    ];
    casks = [
      "1password-cli"
      "claude-code@latest"
      "ghostty"
      "podman-desktop"
      "raycast"
      "session-manager-plugin"
      "the-unarchiver"
    ];
    taps = [
      "anomalyco/tap"
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
