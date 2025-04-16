{
  self,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";
  environment.systemPackages = with pkgs; [
    alejandra
    git
    unzip
    zip
    neovim
    wget
    alacritty
    jq
    xq-xml
    btop
    curl
    google-chrome
    tmux
    fzf
    watch
    ripgrep
    cmake
    gcc
    libiconv
    libwebp
    pkg-config
    cmake
  ];
  programs.zsh = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];
}
