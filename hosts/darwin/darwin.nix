{
  self,
  pkgs,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  users.users.attilabanga = {
    home = "/Users/attilabanga";
    shell = pkgs.zsh;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.defaults.NSGlobalDomain = {
    _HIHideMenuBar = false;
  };
  system.defaults.dock = {
    autohide = true;
  };

  homebrew = {
    enable = true;
    #taps = [ "homebrew/cask" ];
    casks = [];
  };

  programs.zsh = {
    enable = true;
    shellInit = ''
      bindkey -s -M vicmd ' ss' 'igcssh\n'
      bindkey -s -M vicmd ' bl' 'ibuild_logs\n'
      bindkey -s -M vicmd ' bs' 'ibuild_stop\n'
      bindkey -s -M vicmd ' bw' 'iwatch_builds\n'
      bindkey -s -M vicmd ' sp' 'ipickupbirdssh\n'
      bindkey -s -M vicmd ' sd' 'idigiloopssh\n'
    '';
  };

  environment.extraInit = ''
    export PATH="$PATH:/Applications/smcFanControl.app/Contents/Resources"
  '';

  security.pam.enableSudoTouchIdAuth = true;
  environment = {
    etc."pam.d/sudo_local".text = ''
      # Managed by Nix Darwin
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      auth       sufficient     pam_tid.so
    '';
  };
}
