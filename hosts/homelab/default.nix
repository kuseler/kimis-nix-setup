{ config, lib, pkgs, ... }:

{
  imports = [
    ../../nixos
  ];

  networking.hostName = "homelab";
}
