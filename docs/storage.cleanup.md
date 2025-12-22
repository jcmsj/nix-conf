# Cleaning nix store
Show: total size of nix store, + ranked
du -hac /nix/store/ --max-depth 1 | sort -h

# Cleaning docker
docker image prune --all
https://stackoverflow.com/questions/46672001/is-it-safe-to-clean-docker-overlay2
