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
      "--tls-san=homelab.fritz.box"
      "--cluster-cidr=10.42.0.0/16,fd00:42::/56" 
      "--service-cidr=10.43.0.0/16,fd00:43::/112"
      "--node-ip=192.168.1.80,fd3d:1e0e:3e6a:0:b25c:daff:fe2a:3de2"
      "--flannel-ipv6-masq=true"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];
  networking.firewall.allowedUDPPorts = [ 8472 ];
  networking.hostName = "homelab";

  environment.systemPackages = with pkgs; [ 
  k3s
  nfs-utils
  fluxcd
  (wrapHelm kubernetes-helm {
        plugins = with pkgs.kubernetes-helmPlugins; [
          helm-secrets
          helm-diff
          helm-s3
          helm-git
        ];
      })
  ];
}
