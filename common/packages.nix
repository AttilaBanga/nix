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
  programs.tmux = {
    enable = true;
    plugins = [
      pkgs.tmuxPlugins.catppuccin
    ];
    extraConfig = ''
         	set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel
      set -g default-terminal "screen-256color"

      set -g @catppuccin_flavour 'macchiato'

      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_number_position "right"

      set -g @catppuccin_status_modules_right "application"
      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator ""
      set -g @catppuccin_status_right_separator_inverse "no"
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"

      set -g @catppuccin_directory_text "#{pane_current_path}"
      run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
    '';
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
}
