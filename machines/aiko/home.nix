{
  config,
  lib,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (
      final: prev: {
        rofi-power-menu = prev.rofi-power-menu.overrideAttrs (old: {
          src = prev.fetchFromGitHub {
            owner = "inalone";
            repo = "rofi-power-menu";
            rev = "fcb5c0bbdd7b732b24ce082229e1876a5ce813f7";
            hash = "sha256-eaL24sf9cpT5XQZk2zgdbMUd58bgagr/Oe8GwZ8RMNs=";
          };
        });
      }
    )
  ];

  imports = [
    ./programs/neovim
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "23.11";
  home.file = {
    "/home/user/.config/sway/wallpaper.png".source = ./wallpaper.png;
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Hack"];})

    font-awesome
    hack-font
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji

    calibre
    htop
    neofetch
    okular
    pavucontrol
    supersonic-wayland
    tigervnc
    wl-clipboard
    xdg-utils
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  services.syncthing.enable = true;

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
    firefox.enable = true;

    fish = {
      enable = true;
      interactiveShellInit = ''
               if not set -q TMUX
                 exec tmux
               end

               set -g fish_greeting

        direnv hook fish | source
      '';
      loginShellInit = ''
        if test (id --user $USER) -ge 1000 && test (tty) = "/dev/tty1"
          exec sway
        end
      '';
    };

    foot = {
      enable = true;
      settings = {
        main = {
          include = "${pkgs.foot.themes}/share/foot/themes/gruvbox-dark";
          term = "xterm-256color";
          font = "Hack:size=12";
        };
      };
    };

    git = {
      enable = true;
      userName = "inalone";
      userEmail = "me@inal.one";
      aliases = {
      };
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks = {
        "server" = {
          hostname = "server";
          user = "administrator";
        };
        "server-local" = {
          hostname = "10.10.10.10";
          user = "administrator";
        };
      };
    };

    rofi = {
      enable = true;
      package = pkgs.rofi-wayland.override {
        plugins = [
          pkgs.rofi-calc
          pkgs.rofi-power-menu
        ];
      };
      theme = "gruvbox-dark";
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      escapeTime = 0;
      extraConfig = ''
               set -sa terminal-overrides ",xterm*:Tc"
        bind-key -n M-! select-window -t 1
               bind-key -n M-@ select-window -t 2
               bind-key -n M-# select-window -t 3
               bind-key -n M-% select-window -t 4
               bind-key -n M-^ select-window -t 5
               bind-key -n M-& select-window -t 6
               bind-key -n M-* select-window -t 7
               bind-key -n M-( select-window -t 8
               bind-key -n M-) select-window -t 9
      '';
      historyLimit = 100000;
      mouse = true;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.gruvbox;
          extraConfig = ''
            set -g @plugin 'egel/tmux-gruvbox'
                   set -g @tmux-gruvbox 'dark'
          '';
        }
        {plugin = tmuxPlugins.sensible;}
      ];
      prefix = "C-a";
      terminal = "tmux-256color";
    };

    waybar = {
      enable = true;
      settings = {
        bar = {
          layer = "top";
          height = 30;
          position = "bottom";
          modules-left = ["sway/workspaces" "sway/mode"];
          modules-center = [];
          modules-right = ["network" "wireplumber" "battery" "clock"];

          battery = {
            format = "{capacity}% {icon}";
            format-icons = ["" "" "" "" ""];
            states = {
              warning = 25;
              critical = 10;
            };
          };

          clock = {
            format = "{:%a %d-%m-%Y %H:%M}";
          };

          network = {
            format = "{icon}";
            format-alt = "{ipaddr}/{cidr} {icon}";
            format-disconnected = "";
            format-icons = {
              wifi = [""];
              ethernet = [""];
            };
          };

          wireplumber = {
            format = "{volume}% {icon}";
            format-muted = "";
            format-icons = ["" "" ""];
          };
        };
      };
      style = builtins.readFile ./waybar.css;
    };
  };

  services.wlsunset = {
    enable = true;
    latitude = "51.5662";
    longitude = "-0.1439";
  };

  wayland.windowManager.sway = {
    enable = true;

    config = rec {
      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
        }
      ];
      colors = let
        gruvboxRed = "#fb4934";
        gruvboxWhite = "#fbf1c7";
        gruvboxYellowDark = "#d79921";
        gruvboxYellowLight = "#fabd2f";
      in {
        focused = {
          border = "${gruvboxYellowDark}";
          background = "${gruvboxYellowDark}";
          text = "${gruvboxWhite}";
          indicator = "${gruvboxYellowLight}";
          childBorder = "${gruvboxYellowDark}";
        };
        focusedInactive = {
          border = "${gruvboxYellowDark}";
          background = "${gruvboxYellowDark}";
          text = "${gruvboxWhite}";
          indicator = "${gruvboxYellowLight}";
          childBorder = "${gruvboxYellowDark}";
        };
        unfocused = {
          border = "${gruvboxYellowLight}";
          background = "${gruvboxYellowLight}";
          text = "${gruvboxWhite}";
          indicator = "${gruvboxYellowLight}";
          childBorder = "${gruvboxYellowLight}";
        };
        urgent = {
          border = "${gruvboxRed}";
          background = "${gruvboxRed}";
          text = "${gruvboxWhite}";
          indicator = "${gruvboxYellowLight}";
          childBorder = "${gruvboxYellowLight}";
        };
      };

      gaps = {
        inner = 2;
        outer = 2;
        smartGaps = true;
      };
      modifier = "Mod4";
      menu = "${pkgs.rofi-wayland}/bin/rofi -show drun";
      terminal = "${pkgs.foot}/bin/foot";
      input = {
        "type:touchpad" = {
          tap = "enabled";
        };
      };
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in
        lib.mkOptionDefault {
          "${modifier}+c" = "exec ${pkgs.rofi-wayland}/bin/rofi -show calc -modi calc -no-show-match -no-sort -calc-command \"echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy\"";
          "${modifier}+p" = "exec ${pkgs.rofi-wayland}/bin/rofi -show power-menu -modi power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";

          "${modifier}+Shift+s" = "sticky toggle";
          "${modifier}+Delete" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";

          "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        };
      output = {
        "*" = {
          bg = "~/.config/sway/wallpaper.png fill";
        };
        eDP-1 = {
          scale = "1.0";
        };
      };
    };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/epub+zip" = ["org.kde.okular.desktop"];
      "application/pdf" = ["org.kde.okular.desktop"];
    };
  };

  # Reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
