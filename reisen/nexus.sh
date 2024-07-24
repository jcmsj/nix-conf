#!/bin/env sh
if [ -z "$1" ]; then
    echo "Usage: nexus <target>"
    echo "Targets:"
    echo "  active: Currently active window."
    echo "  screen: All visible outputs."
    echo "  output: Currently active output."
    echo "  area: Manually select a region or window."
    echo " Reference: https://github.com/hyprwm/contrib/blob/main/grimblast/grimblast#L109"
    exit 1
fi

target=$1
output=/tmp/$(date -Ins).png
swappy -f $(grimblast --notify copysave $target $output)
rm $output
