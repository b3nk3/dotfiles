# modules/homebrew/personal.nix
# Homebrew packages for personal machines (macbook)
{ ... }:
{
  homebrew = {
    brews = [
      "ffmpeg"
    ];
    casks = [
      "bifrost"
      "iina"
    ];
    taps = [ ];
  };
}
