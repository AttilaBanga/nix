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
    waybar
    tofi
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    # ".zshrc".source = dotfiles/.zshrc;
    ".config/hypr/hyprland.conf".source = dotfiles/hyprland.conf;
    ".config/waybar/config.jsonc".source = dotfiles/config.jsonc;
    ".config/waybar/style.css".source = dotfiles/style.css;
    ".config/tofi/config".source = dotfiles/tofi.conf;

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


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
