# modules/homebrew/personal.nix
# Homebrew packages for personal machines (macbook)
{ ... }:
{
  homebrew = {
    brews = [
      "python"
      "uv"
    ];
    casks = [
      "claude-code"
      "iina"
    ];
    taps = [ ];
  };
}
