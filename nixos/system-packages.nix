{ pkgs, ... }:

{
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
  ];
}
