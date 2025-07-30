{ pkgs, lib,... }:
{
  environment.shellAliases = {
    sudo = "sudo ";
    "ls-gens" = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
    "rm-gens" = "nix-env --profile /nix/var/nix/profiles/system --delete-generations";
    pn = "pnpm";
    pnx = "pnpm dlx";
    py = "python";
    pull = "git pull";
    push = "git push";
    hm = "home-manager";
    remake = "reisen remake";
    zd = "nix develop -c $SHELL";
    dev = "npm run dev";
  };
  environment.localBinInPath = true;
  environment.sessionVariables = rec {
    # CHROME_EXECUTABLE = "google-chrome-unstable";
    # MOZ_ENABLE_WAYLAND = "1";
    # If cursor becomes invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    PNPM_HOME = "$HOME/.pnpm";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    OLLAMA_MODELS="/media/kozue/llm_models";
    # VSCODE_EXTENSIONS = "/opt/code/extensions";
    # GRIMBLAST_EDITOR = "swappy";
    # NOTIFICATION_TIMEOUT = "5"; # in seconds
    # TODO: restore if QT apps don't follow theme
    # QT_QPA_PLATFORM = "wayland;xcb";
    # QT_QPA_PLATFORMTHEME = "adwaita";
    # QT_STYLE_OVERRIDE = "adwaita-dark";
    # For nautilus to show media information
    GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-libav
    ]);

    NODE_OPTIONS = "--max_old_space_size=8192";
  };
}
