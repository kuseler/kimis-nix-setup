# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Registry pinning: ensure 'nix shell nixpkgs#package' uses the same version as the system
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/kuseler/kimis-nix-setup.git";
	branches.main.name = "master"; # Make sure this matches your git branch!
      }
    ];
  };

  # zsh
  users.defaultUserShell = pkgs.zsh;

  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "agnoster";
    plugins = [ "git" "sudo" "kubectl" ];
  };

  programs.zsh.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
    
    # Optional: If you use plugins that are installed via Nix packages (like zsh-autosuggestions)
    # you might want to export their paths here too.
    # export ZSH_AUTOSUGGESTIONS=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions
  '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = true;
  networking.hostName = "homelab"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
users.users.kimi = {
   isNormalUser = true;
   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   home = "/home/kimi";
   useDefaultShell = true;
   packages = with pkgs; [
   tree
   ];
   openssh.authorizedKeys.keys = [
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzIJI/y8Qwdf150SAkZJwbOib7SjrI+h4DEdo10Utl9" 
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwjxE/bHVO6ytRz5zstXqIbrDiH2u04AwbEsB/L2nb+2y2jKNdSrGH13GGxrD5HkgElh9v9r3vfAx2pN0DwFBNt4dvtnlmRleovsBWvgxxYHN4V6aaQEof/GaHpxuo2cU/Mykqxl2frsvX0xzW64tMAs5mgmgU0StoaWU6dQaJiWc9sVwfuiQJMdA/nV9fCQc2VpV1Z/JcrSBjOGQ8ex7l7q7i7HmSoXGEiPwvxSpk6u5W95VeH6E4OJkxUR+FiwAncwLNcCSBqEdgEWYMtnxPFizF5yF0P0fT1kcsOBtLczmZT0siIldiQ+nrk33T+60t/LZuzU7pJgmydJDKkp+83FiHy2tw2WubCF0rNus79T6DXBHyu/TdGK0GrAL0wx5cyY/MKTCGnEtsZ2eP1XzQNc9aL03DbmRI80UlYaI9NK0rhE9rlb1tIb2GGNh2MV2zXoglw41Rt4l0XVlanoI+256qqhHDxGlb5Q+0VfKk/t6USFE2L6OwXacSZMAdM3k4IzA9HCKjy/jg6cLEAl+Z2685LwapgHXnnWM3qLb0zfmNm0nJn5qs/qaPUKAQWU13ypgGOPYwqcWfN/7KZ7p0Hfx6CY/mkCyjI8vsnq8HJ8EIjLEhTUPn2OnjbotloFy4BROEN6rfpC5fBlFuLX9NRvH9qQzBYy/98HtG6nEdEw== kimi@kimiarch"
   ];
};

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    gemini-cli
    neofetch      # system info summary
    btop          # modern, visually rich resource monitor
    curl
    dnsutils      # for 'dig' and 'nslookup'
    iperf3        # network speed testing
    neovim
    git
    jq            # command-line JSON processor
    ripgrep       # fast search tool (better grep)
    fd            # fast file finding (better find)
    unzip
    zip
    tree
    zsh		  # terminal
    wget
    k9s
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

