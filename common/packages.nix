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
    python3
    fzf
    watch
    ripgrep
    cmake
    gcc
  ];
  programs.zsh = {
    enable = true;
  };

}
