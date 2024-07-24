{ pkgs, lib,... }:
{
  environment.shellAliases = {
    sudo = "sudo ";
    "ls-gens" = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
    "rm-gens" = "nix-env --profile /nix/var/nix/profiles/system --delete-generations";
    pn = "pnpm";
    pnx = "pnpm dlx";
    py = "python";
    hm = "home-manager";
    remake = "reisen remake";
  };
  environment.localBinInPath = true;
  environment.sessionVariables = rec {
    CHROME_EXECUTABLE = "google-chrome-unstable";
    MOZ_ENABLE_WAYLAND = "1";
    # If cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    PNPM_HOME = "$HOME/.pnpm";
    NIXOS_OZONE_WL = "1";
    VSCODE_EXTENSIONS = "/opt/code/extensions";
    GRIMBLAST_EDITOR = "swappy";
    NOTIFICATION_TIMEOUT = "5"; # in seconds

    # For nautilus to show media information
    GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-libav
    ]);
    # XDG_RUNTIME_DIR="/run/user/$UID"; # Unlocks gnome keyring in time
    # gnomeAuthAgent = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };
}
