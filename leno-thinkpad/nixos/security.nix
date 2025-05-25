{ config, lib, pkgs, ... }:

{
  # Harden kernel.
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2; # Hide kernel pointers.
    "net.ipv4.tcp_rfc1337" = 1; # Avoid tcp time-wait assassination hazards - drop RST packets for sockets in the time-wait state.
    "net.ipv4.conf.all.rp_filter" = 1; # Reverse path filtering.
    "net.ipv4.conf.conf.rp_filter" = 1; # Reverse path filtering.
    "net.ipv4.conf.default.accept_source_route" = 0; # Do not accept source routing.
    "net.ipv4.conf.default.log_martians" = 1; # Log packets with impossible addresses.
    "net.ipv4.conf.all.log_martians" = 1; # Log packets with impossible addresses.
    #"net.core.bpf_jit_enable" = 0; # Avoid spray attacks.
    "net.core.bpf_jit_harden" = 2;

    # Mitigate SYN flooding.
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_synack_retries" = 5;
    # Disable ICM redirect messages that can be used for MiTM attacks.
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
  };

  boot.kernelParams = [
    "slab_nomerge" # Do not merge slabs.
    "page_poison=1" # Overwrite freed pages.
    "page_alloc.shuffle=1" # Enable page alloc randomization.
  ];

  # Cloudlfare DNS.
  networking.nameservers = [ "1.1.1.1" "1.1.0.0" ];

  # Randomize MAC Address.
  networking.networkmanager.wifi.macAddress = "random";

  # Use sudo-rs instead of sudo.
  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    execWheelOnly = true; # Only wheel group members can use sudo.
    wheelNeedsPassword = true;
  };

  # Disable SMT.
  #security.allowSimultaneousMultithreading = false;

  # Enable PTI.
  #security.forcePageTableIsolation = true;

  # Paranoid options.
  #security.allowUserNamespaces = false;
  #security.virtualisation.flushL1DataCache = "always";
  #networking.tcpcrypt.enable = true;

}
