{ pkgs, nodejs }:
pkgs.writeShellScriptBin "pnpm" "exec \"${pkgs.lib.getBin nodejs}/bin/node\" \"${pkgs.lib.getBin nodejs}/bin/corepack\" pnpm \"$@\""
