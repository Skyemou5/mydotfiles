# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # experimental-features = nix-command flakes;

  # Set your time zone.
  time.timeZone = "America/Denver";

  nix.extraOptions = ''
  experimental-features = nix-command
  '';

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

fileSystems = {
  "/mnt/MegaStomach1" = {
    device = "/dev/disk/by-uuid/BE627C17627BD31F";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=1000" "nosuid" "nodev" "nofail" "x-gvfs-show" ];
  };
  "/mnt/MediumStomach" = {
    device = "/dev/disk/by-uuid/201CA8AE1CA88080";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=1000" "nosuid" "nodev" "nofail" "x-gvfs-show" "label=Medium Stomach" ];
  };
  "/mnt/MediumStomach2" = {
    device = "/dev/disk/by-uuid/0CF09AB2F09AA20E";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=1000" "nosuid" "nodev" "nofail" "x-gvfs-show" "label=Medium Stomach 2" ];
  };
  "/mnt/Stomach" = {
    device = "UUID=5d186591-57ec-44d8-9b80-0e653a619fda";
    fsType = "ext4";
    options = [ "defaults" ];
  };
};

  

  # configuration.nix gaming

  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };


  # Flatpak
  services.flatpak.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  nixpkgs.config.permittedInsecurePackages = [
     "python-2.7.18.6"
     "electron-12.2.3"
  ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.skye = {
    isNormalUser = true;
    description = "Skye";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      discord
    ];
  };
  
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
        extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
          libgdiplus
        ]);
      });
    })
  ];
  



virtualisation.containers.enable = true;
 
  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "skye";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;


  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.modesetting.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #wget
    pkgs.etcher
    pkgs.krita
    pkgs.heroic
    #pkgs.davinci-resolve
    pkgs.obsidian
    pkgs.podman
    pkgs.distrobox
    pkgs.inkscape-with-extensions
    pkgs.gimp-with-plugins
    pkgs.houdini
    pkgs.blender
    pkgs.unityhub
    pkgs.godot_4
    pkgs.python39
    pkgs.rustup
    #pkgs.lua
    pkgs.mono
    pkgs.prismlauncher
    pkgs.bottles-unwrapped
    pkgs.lutris-unwrapped
    pkgs.protonup-qt
    pkgs.protontricks
    pkgs.winetricks
    pkgs.peek
    pkgs.ksnip
    pkgs.neovim
    pkgs.emacs
    pkgs.kitty
    pkgs.kitty-themes
    pkgs.tidal-hifi
    pkgs.steam
    pkgs.gnome-extension-manager
    pkgs.vscodium-fhs
    pkgs.element-desktop
    (steam.override {
       extraPkgs = pkgs: [ bumblebee glxinfo ];
    }).run
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
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
