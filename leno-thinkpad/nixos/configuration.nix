# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix # hardware scan.
      ./security.nix # security module.
      ./iptables.nix # netfilter.
      ./systemd.nix # systemd services hardening.
      ./firefox.nix # firefox policies.json/user.js.
      ./home-manager/main.nix # home dotfiles.
    ];

  nixpkgs.config.allowUnfree = true;
  
  boot.initrd = {
    luks.devices = {
      luksCrypted = {
        device = "/dev/disk/by-uuid/2f8b538b-575f-4afd-a325-6c7071e483fe";
        preLVM = true; # unlock before activating LVM.
        allowDiscards = true;
      };
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Disable systemd and bios naming schemes.
  boot.kernelParams = [
    "net.ifnames=0"
    "biosdevname=0"
  ];

  # Basic networking configuration.
  networking.hostName = "t480";
  networking.networkmanager.enable = true;

  # Disable bluetooth.
  #boot.kernelModules = [ "btusb" ];
  hardware.bluetooth = {
    enable = false;
  #  powerOnBoot = false;
  #  settings = {
  #    General = {
  #      Enable = "Source,Sink,Media,Socket"; # A2DP
  #      ControllerMode = "bredr";
  #    };
  #  };
  };
  #services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "pt_BR.UTF-8";
    supportedLocales = [ "pt_BR.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };
  console = {
    keyMap = lib.mkForce "br-abnt2";
    useXkbConfig = true;
  };

  # Enable all the nerdfonts.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    liberation_ttf
    dejavu_fonts
    nerdfonts
  ];

  # Hyprland.
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "br";
        variant = "thinkpad";
      };
      displayManager.lightdm.enable = true;
    };
  };

  # Enable sound. Use Pulseaudio only (no Pipewire).
  hardware.pulseaudio.enable = true;
  services.pipewire.enable = false;

  # Enable touchpad support.
  services.libinput.enable = true;

  # Enable upower.
  services.upower.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true; # allow changing password.
  users.users = {
    boutrik = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio" "input" ];
      packages = with pkgs; [
        tree
        alacritty
        waybar
        wofi
        fuzzel
        wl-clipboard
        neofetch
        firefox-wayland
        gnupg
        pinentry
        pinentry-curses
        telegram-desktop
        libreoffice-fresh
        hyprpaper
        brightnessctl
        alsa-utils
        grim
        slurp
        ranger
        ueberzug
      ];
    };
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # GnuPG
  programs.mtr.enable = true;  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    (import ./vim.nix)
    git
    neovim
    wget
    iptables
    pulseaudio
    adwaita-icon-theme
    gtk3
  ];

  # Enable dark theme for GTK applications.
  environment.variables = {
    GTK_THEME = "Adwaita-dark";
    LIBREOFFICE_LANG = "en.US_UTF-8";
  };
  programs.dconf.enable = true;

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "24.11"; # Did you read the comment?

}

