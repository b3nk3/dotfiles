# modules/homebrew/personal.nix
# Homebrew packages for personal machines (macbook)
{ ... }:
{
  homebrew = {
    brews = [
      "baguette"
      "cocoapods"
      "ffmpeg"
      "yt-dlp"
    ];
    casks = [
      "bifrost"
      "iina"
    ];
    taps = [ ];
  };
}
