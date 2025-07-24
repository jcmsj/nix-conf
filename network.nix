{ pkgs, ... }:
{
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # extraHosts = ''
    #   104.16.26.34 registry.npmjs.org
    # '';
    nameservers = [ "1.1.1.1" "1.0.0.1" ];

    # Allow specific TCP ports
    firewall = {
      enable = true;
      allowedTCPPorts = [
        5173 # Your Vite web server
        # Add any other individual TCP ports you need to allow here
      ];

      # Allow TCP port ranges
      allowedTCPPortRanges = [
        { from = 3000; to = 3999; } # For 3xxx range (e.g., 3000, 3001, ..., 3999)
        { from = 8000; to = 8999; } # For 8xxx range (e.g., 8000, 8001, ..., 8999)
        # You can add more ranges here as needed
      ];
    };

    # To be able to use wpa_gui or wpa_cli as user put the following in your
    # networking.wireless.userControlled.enable = true;
    # systemd.services.NetworkManager-wait-online.enable = false;
    # services.mullvad-vpn.enable = true;

    # wifi gui
    # programs.nm-applet = {
    #   enable = true;
    # };
  };
}
