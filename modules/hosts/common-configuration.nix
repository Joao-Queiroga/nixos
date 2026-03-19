{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-gtk3-1.1.10"
    "ventoy-gtk3-1.1.07"
  ];
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.use-xdg-base-directories = true;
  nix.settings = {
    trusted-users = ["root" "@wheel"];
    substituters = ["https://hyprland.cachix.org" "https://attic.xuyh0120.win/lantian"];
    trusted-substituters = ["https://hyprland.cachix.org" "https://attic.xuyh0120.win/lantian"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
    lazy-trees = true;
  };
  nix.optimise.automatic = true;

  boot = {
    plymouth.enable = true;
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        zfsSupport = true;
        timeoutStyle = "hidden";
        mirroredBoots = [
          {
            devices = ["nodev"];
            path = "/boot";
            efiSysMountPoint = "/boot/efi";
            efiBootloaderId = "NixOS";
          }
        ];
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      timeout = 0;
    };
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "kbd.numlock=1"
    ];
  };

  boot = {
    kernelPackages = lib.mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
    zfs.package = config.boot.kernelPackages.zfs_cachyos;
  };

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  networking.firewall.checkReversePath = false;

  time.timeZone = "Brazil/East";

  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.geoclue2.enable = true;
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.xserver.xkb.layout = "br";
  services.xserver.xkb.options = "numlock:on";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-spatializer-7.1.conf" (let
        hrirPath = ''"''${HOME}/.config/pipewire/hrir.wav"'';
      in ''
              context.modules = [
            { name = libpipewire-module-filter-chain
                flags = [ nofail ]
                args = {
                    node.description = "Virtual Surround Sink"
                    media.name       = "Virtual Surround Sink"
                    filter.graph = {
                        nodes = [
                            # duplicate inputs
                            { type = builtin label = copy name = copyFL  }
                            { type = builtin label = copy name = copyFR  }
                            { type = builtin label = copy name = copyFC  }
                            { type = builtin label = copy name = copyRL  }
                            { type = builtin label = copy name = copyRR  }
                            { type = builtin label = copy name = copySL  }
                            { type = builtin label = copy name = copySR  }
                            { type = builtin label = copy name = copyLFE }

                            # apply hrir - HeSuVi 14-channel WAV (not the *-.wav variants) (note: */44/* in HeSuVi are the same, but resampled to 44100)
                            { type = builtin label = convolver name = convFL_L config = { filename = ${hrirPath} channel =  0 } }
                            { type = builtin label = convolver name = convFL_R config = { filename = ${hrirPath} channel =  1 } }
                            { type = builtin label = convolver name = convSL_L config = { filename = ${hrirPath} channel =  2 } }
                            { type = builtin label = convolver name = convSL_R config = { filename = ${hrirPath} channel =  3 } }
                            { type = builtin label = convolver name = convRL_L config = { filename = ${hrirPath} channel =  4 } }
                            { type = builtin label = convolver name = convRL_R config = { filename = ${hrirPath} channel =  5 } }
                            { type = builtin label = convolver name = convFC_L config = { filename = ${hrirPath} channel =  6 } }
                            { type = builtin label = convolver name = convFR_R config = { filename = ${hrirPath} channel =  7 } }
                            { type = builtin label = convolver name = convFR_L config = { filename = ${hrirPath} channel =  8 } }
                            { type = builtin label = convolver name = convSR_R config = { filename = ${hrirPath} channel =  9 } }
                            { type = builtin label = convolver name = convSR_L config = { filename = ${hrirPath} channel = 10 } }
                            { type = builtin label = convolver name = convRR_R config = { filename = ${hrirPath} channel = 11 } }
                            { type = builtin label = convolver name = convRR_L config = { filename = ${hrirPath} channel = 12 } }
                            { type = builtin label = convolver name = convFC_R config = { filename = ${hrirPath} channel = 13 } }

                            # treat LFE as FC
                            { type = builtin label = convolver name = convLFE_L config = { filename = ${hrirPath} channel =  6 } }
                            { type = builtin label = convolver name = convLFE_R config = { filename = ${hrirPath} channel = 13 } }

                            # stereo output
                            { type = builtin label = mixer name = mixL }
                            { type = builtin label = mixer name = mixR }
                        ]
                        links = [
                            # input
                            { output = "copyFL:Out"  input="convFL_L:In"  }
                            { output = "copyFL:Out"  input="convFL_R:In"  }
                            { output = "copySL:Out"  input="convSL_L:In"  }
                            { output = "copySL:Out"  input="convSL_R:In"  }
                            { output = "copyRL:Out"  input="convRL_L:In"  }
                            { output = "copyRL:Out"  input="convRL_R:In"  }
                            { output = "copyFC:Out"  input="convFC_L:In"  }
                            { output = "copyFR:Out"  input="convFR_R:In"  }
                            { output = "copyFR:Out"  input="convFR_L:In"  }
                            { output = "copySR:Out"  input="convSR_R:In"  }
                            { output = "copySR:Out"  input="convSR_L:In"  }
                            { output = "copyRR:Out"  input="convRR_R:In"  }
                            { output = "copyRR:Out"  input="convRR_L:In"  }
                            { output = "copyFC:Out"  input="convFC_R:In"  }
                            { output = "copyLFE:Out" input="convLFE_L:In" }
                            { output = "copyLFE:Out" input="convLFE_R:In" }

                            # output
                            { output = "convFL_L:Out"  input="mixL:In 1" }
                            { output = "convFL_R:Out"  input="mixR:In 1" }
                            { output = "convSL_L:Out"  input="mixL:In 2" }
                            { output = "convSL_R:Out"  input="mixR:In 2" }
                            { output = "convRL_L:Out"  input="mixL:In 3" }
                            { output = "convRL_R:Out"  input="mixR:In 3" }
                            { output = "convFC_L:Out"  input="mixL:In 4" }
                            { output = "convFC_R:Out"  input="mixR:In 4" }
                            { output = "convFR_R:Out"  input="mixR:In 5" }
                            { output = "convFR_L:Out"  input="mixL:In 5" }
                            { output = "convSR_R:Out"  input="mixR:In 6" }
                            { output = "convSR_L:Out"  input="mixL:In 6" }
                            { output = "convRR_R:Out"  input="mixR:In 7" }
                            { output = "convRR_L:Out"  input="mixL:In 7" }
                            { output = "convLFE_R:Out" input="mixR:In 8" }
                            { output = "convLFE_L:Out" input="mixL:In 8" }
                        ]
                        inputs  = [ "copyFL:In" "copyFR:In" "copyFC:In" "copyLFE:In" "copyRL:In" "copyRR:In", "copySL:In", "copySR:In" ]
                        outputs = [ "mixL:Out" "mixR:Out" ]
                    }
                    capture.props = {
                        node.name      = "effect_input.virtual-surround-7.1-hesuvi"
                        media.class    = Audio/Sink
                        audio.channels = 8
                        audio.position = [ FL FR FC LFE RL RR SL SR ]
                    }
                    playback.props = {
                        node.name      = "effect_output.virtual-surround-7.1-hesuvi"
                        node.passive   = true
                        audio.channels = 2
                        audio.position = [ FL FR ]
                    }
                }
            }
        ]
      ''))
    ];
  };

  services.flatpak.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      vulkan-tools
    ];
  };

  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec "$(command -v fish || echo ${pkgs.fish}/bin/fish)" $LOGIN_OPTION
      fi
    '';
  };

  users.users.joaoqueiroga = {
    isNormalUser = true;
    description = "João Queiroga";
    extraGroups = [
      "wheel"
      "networkmanager"
      "gamemode"
    ];
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
    };
    chromium.enable = true;
    nix-ld.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    kdeconnect.enable = true;
    niri = {
      enable = true;
      package = import ../wrappers/niri.nix {
        inherit pkgs inputs config lib;
      };
    };

    uwsm.waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = lib.mkForce "${pkgs.writeShellScriptBin "Hyprland" ''
        #!/bin/sh
        exec start-hyprland "$@"
      ''}/bin/Hyprland";
    };
    thunar.enable = true;
    neovim.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    wineWowPackages.waylandFull
    btop
    file
    kitty
    unzip
    ventoy-full-gtk
    gparted
    exfatprogs
    rose-pine-cursor
    killall
  ];
  environment.binsh = "${pkgs.dash}/bin/dash";

  services.displayManager = {
    environment = {
      XKB_DEFAULT_LAYOUT = "br";
    };
    sddm = {
      enable = true;
      autoNumlock = true;
      theme = "${
        (pkgs.sddm-astronaut.override {embeddedTheme = "black_hole";})
      }/share/sddm/themes/sddm-astronaut-theme/";
      wayland.enable = true;
      extraPackages = with pkgs.kdePackages; [
        qtmultimedia
        qtsvg
        qtvirtualkeyboard
      ];
      settings = {
        Theme = {
          CursorTheme = config.stylix.cursor.name;
          CursorSize = config.stylix.cursor.size;
        };
        Wayland.CompositorCommand = let
          xcfg = config.services.xserver;
          westonIni = (pkgs.formats.ini {}).generate "weston.ini" {
            libinput = {
              enable-tap = config.services.libinput.mouse.tapping;
              left-handed = config.services.libinput.mouse.leftHanded;
            };
            keyboard = {
              keymap_model = xcfg.xkb.model;
              keymap_layout = xcfg.xkb.layout;
              keymap_variant = xcfg.xkb.variant;
              keymap_options = xcfg.xkb.options;
              numlock-on = config.services.displayManager.sddm.autoNumlock;
            };
          };
        in "${lib.getExe pkgs.weston} --shell=kiosk -c ${westonIni}";
      };
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
    override = {
      base05 = "#c0caf5";
      base09 = "#faba4a";
      base0B = "#9ece6a";
    };
    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 27;
    };
    polarity = "dark";
    targets.grub.useWallpaper = false;
    targets.chromium.enable = false;
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = builtins.concatLists (
      map (name: [
        "--update-input"
        name
      ]) (builtins.attrNames inputs)
    );
    dates = "2:00";
    randomizedDelaySec = "45min";
  };

  system.stateVersion = "25.05";
}
