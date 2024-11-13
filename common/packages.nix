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
    docker
    fzf
    watch
    ripgrep
    cmake
    gcc
    libiconv
  ];
  programs.zsh = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
  ];
}
