conf=$HOME/.config/nix-conf
remake() {
    shift 1
    sudo nixos-rebuild switch --flake $conf $@;
}

update() {
    shift 1
    nix flake update $conf $@;
}
latest() {
    update
    # notify password prompt
    notify-send "NixOS" "Password prompt for nixos-rebuild" -u critical -t 0
    remake
}

listPkgs() {
    # find /nix/store/ -maxdepth 1 -type d  | du -sh | sort -h
    # DOES NOT WORK cause of arguments list too long
    du -sh /nix/store/* | sort -h
}

nixProfiles=/nix/var/nix/profiles/system
listGens() {
    sudo nix-env --list-generations --profile $nixProfiles
}
deleteGens() {
    sudo nix-env --delete-generations --profile $nixProfiles $@
}
deleteGensRange() {
    start=$2
    end=$3
    echo "Removing generations from $start to $end"
    echo $start
    echo $end
    deleteGens $(seq $start $end)
}
cleanup() {
    nix-collect-garbage -d $@
}
help() {
    echo "Usage: reisen command]"
    echo "Commands:"
    echo "  remake|re <...args>: Rebuild the system"
    echo "  update <...args>: Update the flake"
    # latest
    echo "  latest: update then remake";
    echo "  pkgs: List all packages in the store sorted by size"
    # del
    echo "  gens: list generations"
    echo "  del n n+1: delete generations"
    echo "  clean: clean the nix store"
    echo "  del-range start end: delete generations in range"
    echo "Note:"
    echo "  additional args are passed to the nix command used"
}

case $1 in
    remake|re)
        remake
        ;;
    update)
        update
        ;;
    latest)
        latest
        ;;
    gens)
        listGens $@
        ;;
    pkgs)
        listPkgs
        ;;
    del)
        deleteGens $@
        ;;
    del-range)
        deleteGensRange $@
        ;;
    clean)
        cleanup $@
        ;;
    *)
        help
        ;;
esac
