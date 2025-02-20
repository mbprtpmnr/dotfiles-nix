{ config, pkgs, ... }:

{
    # Neovim configuration
    imports = [ ./config/nvim/nvim.nix ];

    # Set environment variables
    environment.variables = {
        NIXOS_CONFIG="$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR="$HOME/.config/nixos/";
    };

    # Nix settings, auto cleanup and enable flakes
    nix = {
        autoOptimiseStore = true;
        allowedUsers = [ "notus" ];
        gc = {
            automatic = true;
            dates = "daily";
        };
        package = pkgs.nixUnstable;
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };

    nixpkgs.config.allowBroken = true;

    # Boot settings: clean /tmp/, latest kernel and enable bootloader
    boot = {
        cleanTmpDir = true;
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        }; 
    };

    # Set up locales (timezone and keyboard layout)
    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    # X server settings
    services.xserver = {
        layout = "us";
        enable = true;

        # Display manager and window manager
        displayManager.ly.enable = true;
        windowManager.dwm.enable = true;

        # Touchpad scrolling
        libinput = {
            enable = true;
            touchpad.naturalScrolling = true;
        };
    };

    # Enable audio
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Set up user and enable sudo
    users.users.notus = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; 
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGT2HfLDD+Hp4GjoIIoQ2S6zxQ1m8psYijVfwpLhUoFXEq6X6tsMqn5lGkHmQET2s9BIEHjud4ySLsFn35yqC18WBIGLFkbE0wl9OcMXA06rkZwy6eeLczG0YoOuT0TbQkB2344j5F09e4b04g79jNq6FGJtS8CMyE0NiKu7hHy9+hrbz7aJFd1qzd8zdI9P22fBa9GbGsgVXO8ug9Sk9qk/YZwA+Zg4dNtj3ag6LSUZaSezwU4sb0P4P1wKw0b2u4flq7ZuDHrQlYqCltmv7CpmvtLc85L2raMEbfC0gaPYkO82GSEuOj6B4SuDNyr+3mCVCgFM+Fb2APKsgiUfGkMNE8mfqrUa4pPnqZrwjzM9qYjfl8yOF5NZNEfeJpYybk4FG8Uz47M3U7PXsC9cy4EslESdUvVZZghem1b0ecfIW5T2PlJxde6Rua7sYkkerdsPxo2wqRPzfQz/jR9dFNqKtlx/CxkSQE7x8YBCgoHBjCfQlfvRtGxYo0xzFDFdM= notus@notuslap" ];
    };

    # Install fonts
    fonts.fonts = with pkgs; [
        jetbrains-mono 
        roboto
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    # Set up networking and secure it
    networking = {
        networkmanager.enable = true;
        firewall = {
            enable = true;
            allowedTCPPorts = [ 443 80 8183 53 ];
            allowedUDPPorts = [ 443 80 8183 53 51820 ];
            allowPing = false;
        };
    };

    # Openssh settings for security
    services.openssh = {
        enable = true;
        ports = [ 8183 ];
        permitRootLogin = "no";
        passwordAuthentication = false;
    };

    # Cron jobs
    services.cron = {
        enable = true;
        systemCronJobs = [
            "@reboot endlessh -p 22"
        ];
    };

    # Enable WireGuard
    networking.wireguard.interfaces = {
        wg0 = {
            # Determines the IP address and subnet of the client's end of the tunnel interface.
            ips = [ "73.170.139.156/32" ];
            listenPort = 51820;

            privateKeyFile = "/home/notus/keys/wg-private";

            peers = [
                {
                    publicKey = "ar0hDNb8rINHFOuuzngoUzLGNAvBlnxC2BvIP8VEXVs=";
                    allowedIPs = [ "0.0.0.0/0" ];
                    endpoint = "150.230.34.68:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
                    persistentKeepalive = 25;
                }
            ];
        };
    };

    # Do not touch
    system.stateVersion = "20.09";
    
}
