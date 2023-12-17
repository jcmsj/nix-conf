{
  environment.shellAliases = {
    sudo = "sudo ";
    "ls-gens" = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
    "rm-gens" = "nix-env --profile /nix/var/nix/profiles/system --delete-generations";
    pn = "pnpm";
    py = "python";
  };

  environment.sessionVariables = rec {
    CHROME_EXECUTABLE = "google-chrome-unstable";
    MOZ_ENABLE_WAYLAND = "1";
    # If cursor becomes invisible
    #WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    #NIXOS_OZONE_WL = "1";
  };
}
