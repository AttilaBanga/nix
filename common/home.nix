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
    lombok
    nodejs
    intelephense
    nixd
    yaml-language-server
    lua-language-server
    leptosfmt
    cargo-leptos
    cargo-generate
    rustup
    sass
    tailwindcss
    tailwindcss-language-server
    (python3.withPackages (p: with p; [
        pip
        virtualenv
        pandas
        requests
        tqdm
        tabview
        transformers
        torch
        diffusers
        transformers
        safetensors
        sentencepiece
        huggingface-hub
    ]))
    python3Packages.python-lsp-server
    trunk
    buf
    cargo-watch
    github-cli
    libimobiledevice
    #android-studio
    flutter
    grpcurl
    wrk
    async-profiler
    prometheus
    stylua
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
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
      export DYLD_LIBRARY_PATH=${pkgs.async-profiler}/lib

    '';
  };
  programs.starship = {
    enable = true;
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

  home.activation = {
    setup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.rustup}/bin/rustup default stable
      ${pkgs.rustup}/bin/rustup component add rust-analyzer
      ${pkgs.rustup}/bin/rustup target add wasm32-unknown-unknown
      ${pkgs.rustup}/bin/rustup target add aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
