# modules/homebrew/personal.nix
# Homebrew packages for personal machines (macbook)
{ ... }:
{
  homebrew = {
    brews = [
      "agent-browser"
      "baguette"
      "cocoapods"
      "ffmpeg"
      "yt-dlp"
    ];
    casks = [
      "bifrost"
      "iina"
      "podman-desktop"
    ];
    taps = [ ];
  };
}
