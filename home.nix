{
  config,
  pkgs,
  inputs,
  ...
}:

let
  dots = "${config.home.homeDirectory}/nixos-config/dots";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory mappings
  configs = {
    nvim = "nvim";
    fish = "fish";
    niri = "niri";
    noctalia = "noctalia";
    doom = "doom";
    ghostty = "ghostty";
    alacritty = "alacritty";
    fastfetch = "fastfetch";
  };
in

{
  home.username = "hazem";
  home.homeDirectory = "/home/hazem";
  programs.git.enable = true;
  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      if [ -f ${dots}/bash/.bashrc ]; then
        source ${dots}/bash/.bashrc
      fi
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      package.disabled = true;
      aws.disabled = true;
    };
  };

  # Map your configs to ~/.config
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dots}/${subpath}";
  }) configs;

  home.file = {
    ".tmux.conf".source = create_symlink "${dots}/tmux/.tmux.conf";
    ".tmux.conf.local".source = create_symlink "${dots}/tmux.conf.local";
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.config/emacs/bin" ];

  home.packages = with pkgs; [
    ghostty alacritty tmux
    htop btop
    yazi fastfetch lsd tree
    ripgrep fd fzf
    unzip unrar p7zip zstd
    zoxide atuin glow trash-cli jq entr lazygit gh glab cotp pass

    ffmpeg mpv pandoc zathura xdotool tectonic typst

    rustup

    jdk17 android-tools

    nethogs yt-dlp openssl

    chromium

    libvirt virt-manager qemu cloud-utils kubectl docker podman
  ];
}
