conf=$HOME/.config/nix-conf/.#nixos;
remake() {
    sudo nixos-rebuild switch --flake $conf;
}

update() {
    nix flake update $conf;
}

listPkgs() {
    # find /nix/store/ -maxdepth 1 -type d  | du -sh | sort -h
    # DOES NOT WORK cause of arguments list too long
    # du -sh /nix/store/* | sort -h
    echo TODO;
}

help() {
    echo "Usage: reisen command]";
    echo "Commands:";
    echo "  remake: Rebuild the system";
    echo "     Note: Dont use sudo, it will invoke it itself";
    echo "  update: Update the flake";
    echo "  pkgs: List all packages in the store sorted by size";
}

case $1 in
    remake)
        remake
        ;;
    update)
        update
        ;;
    pkgs)
        listPkgs
        ;;
    *)
        help
        ;;
esac
