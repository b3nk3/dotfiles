# modules/homebrew/personal.nix
# Homebrew packages for personal machines (macbook)
{ ... }:
{
  homebrew = {
    brews = [
      "baguette"
      "cocoapods"
      "fastlane"
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
