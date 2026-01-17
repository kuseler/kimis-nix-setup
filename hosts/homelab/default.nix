{ config, lib, pkgs, ... }:

{
  imports = [
    ../../nixos
  ];

  services.k3s = {
    enable = true;
    role = "server";  # Use "agent" if this is a worker node joininig a cluster
    # Makes the kubeconfig readable so you don't always need sudo for kubectl
    extraFlags = toString [
      "--write-kubeconfig-mode 644"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];
  networking.firewall.allowedUDPPorts = [ 8472 ];
  networking.hostName = "homelab";

  environment.systemPackages = with pkgs; [ 
  k3s 
  helm
  fluxcd
  ];
}
