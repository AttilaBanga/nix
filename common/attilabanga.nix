{
  config,
  pkgs,
  lib,
  ...
}: {
 imports = [
    ./home.nix
 ];
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nmap
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      sail = "[ -f sail ] && sh sail || sh vendor/bin/sail";
      watch_builds = "watch -n 5 builds --limit 5";
    };
    initExtra = ''
      export GOOGLE_APPLICATION_CREDENTIALS="/Users/attilabanga/PhpstormProjects/keys/storage-key.json"
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
    ".config/aerospace/aerospace.toml".source = dotfiles/aerospace.toml;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

}
