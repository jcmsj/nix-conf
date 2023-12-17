#!/usr/bin/env bash 
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
sudo mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.bak
sudo cp configuration.nix /etc/nixos/
sudo cp hardware-configuration.nix /etc/nixos/
sudo cp i18n.nix /etc/nixos/
sudo cp power.nix /etc/nixos/
sudo cp network.nix /etc/nixos/
sudo cp nvidia.nix /etc/nixos/
sudo cp de.nix /etc/nixos/
sudo cp home.nix /etc/nixos/
sudo cp fonts.nix /etc/nixos/
sudo cp bootloader.nix /etc/nixos/
sudo cp sound.nix /etc/nixos/
sudo cp shell-environment.nix /etc/nixos/
