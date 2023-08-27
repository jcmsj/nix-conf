#!/usr/bin/env bash 
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
sudo mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.bak
sudo cp configuration.nix /etc/nixos/
sudo cp hardware-configuration.nix /etc/nixos/
sudo cp i18n.nix /etc/nixos/
sudo cp power.nix /etc/nixos/
