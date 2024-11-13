{
  config,
  pkgs,
  lib,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  #users.users.attilabanga.home = "/home/azridum";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    atuin
    openjdk21
    maven3
    go
    typescript-language-server
    jdt-language-server
    gopls
    google-cloud-sdk
    rustc
    lazygit
    delve
    protobuf_25
    protoc-gen-go
    buf-language-server
    lombok
    nodejs
    intelephense
    nixd
    yaml-language-server
    kitty
    lua-language-server
    leptosfmt
    cargo-leptos
    cargo-generate
    rustup
    sass
    tailwindcss
    tailwindcss-language-server
    python3
    python312Packages.python-lsp-server
    trunk
    cargo-watch
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      sail = "[ -f sail ] && sh sail || sh vendor/bin/sail";
      watch_builds = "watch -n 5 builds --limit 5";
    };
    initExtra = ''
      set -o vi
      eval "$(atuin init zsh)"
      source <(fzf --zsh)
      export LAZY_LOCK=$(pwd)/common/dotfiles/nvim/lazy-lock.json
      export PATH=$PATH:$HOME/bin
      export LOMBOK_JAR="${pkgs.lombok}/share/java/lombok.jar"
      export LIBRARY_PATH=$LIBRARY_PATH:${pkgs.libiconv}/lib
      export GOOGLE_APPLICATION_CREDENTIALS="/Users/attilabanga/PhpstormProjects/keys/storage-key.json"
    '';
  };
  programs.starship = {
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
      set -g default-command "$SHELL"
      set-option -g default-shell $SHELL
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    # ".zshrc".source = dotfiles/.zshrc;
    ".config/alacritty/alacritty.toml".source = dotfiles/alacritty.toml;
    ".config/nvim".source = dotfiles/nvim;
    ".config/alacritty/catppuccin-macchiato.toml".source = dotfiles/catppuccin-macchiato.toml;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.activation.setup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.rustup}/bin/rustup component add rust-analyzer
    ${pkgs.rustup}/bin/rustup target add wasm32-unknown-unknown
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
