{
  config,
  pkgs,
  userinfo,
  ...
}:

{
  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "${userinfo.name}";
    homeDirectory = "/home/${userinfo.name}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.11";

    packages = with pkgs; [
      btop
      fd
      grc
      eza
      ungoogled-chromium
      brave
    ];
    shellAliases = {
      tx = "tmux";
      txn = "tmux new";
      txa = "tmux attach";
      txd = "tmux detach";
      txk = "tmux kill-session";
      txl = "tmux list-sessions";
      dv = "direnv";
      dva = "direnv allow";
      dvs = "direnv status";
      dvk = "direnv revoke";
      dvr = "direnv reload";
      ".." = "cd ..";
      tfmt = "treefmt";
      rb = "sudo nixos-rebuild switch --flake .";
      fu = "sudo nix flake update";
      ga = "git add .";
      gc = "git commit -m";
      gp = "git push -u origin";
      lg = "lazygit";
      az = "yazi";
      nf = "neofetch";
      ff = "fastfetch";
      cl = "clear";
      pm = "pulsemixer";
      v = "fd --type f --hidden --exclude .git | fzf-tmux -p | xargs nvim";
      udm = "udisksctl mount -b";
      udu = "udisksctl unmount -b";
    };
  };
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    fish = {
      enable = true;
      shellAbbrs = config.home.shellAliases;
      shellAliases = {
        ls = "eza";
      };
      interactiveShellInit = ''
        set fish_greeting
        fish_vi_key_bindings

        ${pkgs.fluxcd}/bin/flux completion fish | source
        ${pkgs.talosctl}/bin/talosctl completion fish | source
        ${pkgs.kubectl}/bin/kubectl completion fish | source
        ${pkgs.minikube}/bin/minikube completion fish | source

        # ASDF configuration code
        if test -z $ASDF_DATA_DIR
            set _asdf_shims "$HOME/.asdf/shims"
        else
            set _asdf_shims "$ASDF_DATA_DIR/shims"
        end

        # Do not use fish_add_path (added in Fish 3.2) because it
        # potentially changes the order of items in PATH
        if not contains $_asdf_shims $PATH
            set -gx --prepend PATH $_asdf_shims
        end
        set --erase _asdf_shims

        export GPG_TTY=$(tty)
      '';
      plugins = [
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "colored-man-pages";
          src = pkgs.fishPlugins.colored-man-pages.src;
        }
        {
          name = "fish-kubectl-abbr";
          src = pkgs.fetchFromGitHub {
            owner = "lewisacidic";
            repo = "fish-kubectl-abbr";
            rev = "0.1.0";
            hash = "sha256-x4u8tDuNWMOBFK+5KdF1+k2RJd1vFooRcmEkBXCZZ1M=";
          };
        }
      ];
      functions = {
        "," = ''
          for pkg in $argv
              nix shell nixpkgs#$pkg
          end
        '';
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    thefuck = {
      enable = true;
      enableFishIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      mise.enable = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
