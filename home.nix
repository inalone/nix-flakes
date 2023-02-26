{ config, pkgs, ...}:

{
  home.homeDirectory = "/home/inalone";
  home.stateVersion = "23.05";
  home.username = "inalone";

  home.file."${config.home.homeDirectory}/.config/sway/status_command.sh".source = config.lib.file.mkOutOfStoreSymlink ./status_command.sh;

  programs.home-manager.enable = true;

  services.udiskie.enable = true;

  home.packages = with pkgs; [
    autotiling-rs
    bitwarden
    htop
    inconsolata-nerdfont
    neofetch
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    pavucontrol
    rofi-wayland
    spotify
    xfce.thunar
  ];

  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = {
          normal = {
            family = "Inconsolata Nerd Font Mono";
            style = "Regular";
          };
          bold = {
            family = "Inconsolata Nerd Font Mono";
            style = "Bold";
          };
          italic = {
            family = "Inconsolata Nerd Font Mono";
            style = "Italic";
          };
          bold_italic = {
            family = "Inconsolata Nerd Font Mono";
            style = "Bold Italic";
          };
          size = 14.00;
        };
      };
    };

    git = {
      enable = true;
      userEmail = "me@inal.one";
      userName = "inalone";
    };

    firefox = {
      enable = true;
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      terminal = "alacritty";
      menu = "rofi -show drun";
      
      bars = [{
	fonts.size = 12.0;
        position = "bottom";
	statusCommand = "while date +'%Y-%m-%d %I:%M:%S %p'; do sleep 1; done";
      }];

      fonts = {
        names = [ "Inconsolata Nerd Font Mono" ];
	style = "Regular";
	size = 13.0;
      };

      input = {
        "type:touchpad" = {
          tap = "enabled";
	};
      };

      output = {
        eDP-1 = {
	  scale = "1";
	};
      };

      startup = [
        { command = "autotiling-rs"; }
      ];
    };
  };
}
