inputs: {
  config,
  wlib,
  lib,
  pkgs,
  ...
}: let
  pluginsFromPrefix = prefix: inputs:
    lib.pipe inputs [
      builtins.attrNames
      (builtins.filter (s: lib.hasPrefix prefix s))
      (map (
        input: let
          name = lib.removePrefix prefix input;
        in {
          inherit name;
          value = config.nvim-lib.mkPlugin name inputs.${input};
        }
      ))
      builtins.listToAttrs
    ];

  neovimPlugins = pluginsFromPrefix "plugins-" inputs;
in {
  imports = [wlib.wrapperModules.neovim];

  options = {
    settings.dynamic = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    settings.wrappedConfig = lib.mkOption {
      type = lib.types.either lib.types.path lib.types.luaInline;
      default = ./.;
    };
    settings.unwrappedConfig = lib.mkOption {
      type = lib.types.either lib.types.path lib.types.luaInline;
      default = lib.generators.mkLuaInline "vim.uv.os_homedir() .. '/dev/mevim'";
    };
  };

  config = {
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;

    settings.config_directory =
      if config.settings.dynamic
      then config.settings.unwrappedConfig
      else config.settings.wrappedConfig;

    hosts.python3.nvim-host.enable = false;
    hosts.node.nvim-host.enable = false;
    hosts.ruby.nvim-host.enable = false;
    hosts.perl.nvim-host.enable = false;
    hosts.neovide.nvim-host.enable = false;

    specs.plugins = with neovimPlugins; [
      # Libraries
      nui-nvim
      plenary-nvim
      nvim-lspconfig
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars

      # Plugins
      nvim-lint
      mini-nvim
      leap-nvim
      noice-nvim
      treesj-nvim
      snacks-nvim
      incline-nvim
      conform-nvim
      markview-nvim
      live-preview-nvim
      nvim-colorizer-lua
      colorful-winsep-nvim
    ];

    extraPackages = with pkgs; [
      # Runtime Dependencies
      fd
      fzf
      lazygit
      ripgrep
      stdenv.cc.cc

      # Bundles
      kdePackages.qtdeclarative
      llvmPackages_latest.clang-tools

      # Language Servers
      ty
      nixd
      tombi
      hyprls
      emmylua-ls
      rust-analyzer
      typescript-go
      bash-language-server
      yaml-language-server
      emmet-language-server
      svelte-language-server
      tailwindcss-language-server
      vscode-langservers-extracted

      # Formatters
      ruff
      shfmt
      stylua
      rustfmt
      alejandra
      prettierd

      # Linters
      statix
      selene
      clippy
      cppcheck
      eslint_d
      stylelint
      shellcheck
    ];
  };
}
