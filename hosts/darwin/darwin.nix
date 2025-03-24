{
  self,
  pkgs,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
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
      bindkey -s -M vicmd ' ws' 'ils ~/workspace/syncee | fzf | cd\n'
    '';
  };

  environment.extraInit = ''
    export PATH="$PATH:/Applications/smcFanControl.app/Contents/Resources"
    export PATH="$PATH:/opt/homebrew/bin"
  '';

  security.pam.services.sudo_local.touchIdAuth = true;
  environment = {
    etc."pam.d/sudo_local".text = ''
      # Managed by Nix Darwin
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      auth       sufficient     pam_tid.so
    '';
  };

launchd.daemons.prometheus = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.prometheus}/bin/prometheus"
        "--config.file=${pkgs.writeText "prometheus.yml" (builtins.toJSON {
          global = { scrape_interval = "15s"; };
          scrape_configs = [{
            job_name = "prometheus";
            static_configs = [{ targets = ["localhost:9090"]; }];
          }];
        })}"
        "--storage.tsdb.path=/var/lib/prometheus"
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
