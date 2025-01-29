{
  self,
  pkgs,
  config,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    aerospace
    mkalias
    kafkactl
    cocoapods
    xcodegen
  ];
  # system.activationScripts.postUserActivation.text = ''
  #   apps_source="${config.system.build.applications}/Applications"
  #   moniker="Nix Trampolines"
  #   app_target_base="$HOME/Applications"
  #   app_target="$app_target_base/$moniker"
  #   mkdir -p "$app_target"
  #   ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"
  # '';
}
