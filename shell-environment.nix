{
  environment.shellAliases = {
    sudo = "sudo ";
    "ls-gens" = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
    "rm-gens" = "nix-env --profile /nix/var/nix/profiles/system --delete-generations";
    pn = "pnpm";
    py = "python";
    remake = "cd ~/.config/nix-conf && sudo nixos-rebuild switch --flake .#nixos";
  };
  environment.localBinInPath = true;
  environment.sessionVariables = rec {
    CHROME_EXECUTABLE = "google-chrome-unstable";
    MOZ_ENABLE_WAYLAND = "1";
    # If cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    PNPM_HOME = "$HOME/.pnpm";
    GDK_BACKEND = "wayland";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
}
