# modules/homebrew/personal.nix
# Homebrew packages for personal machines (macbook)
{ ... }:
{
  homebrew = {
    brews = [ ];
    casks = [
      "claude-code"
      "iina"
    ];
    taps = [ ];
  };
}
