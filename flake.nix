{
  description = "Mevim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # Flakes
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-treesitter-main = {
      url = "github:iofq/nvim-treesitter-main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plugins
    # Libraries
    plugins-nui-nvim = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    plugins-plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    plugins-nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    # Editor Plugins
    blink-pairs = {
      url = "github:saghen/blink.pairs";
    };
    plugins-leap-nvim = {
      url = "git+https://codeberg.org/andyg/leap.nvim";
      flake = false;
    };
    plugins-nvim-lint = {
      url = "github:mfussenegger/nvim-lint";
      flake = false;
    };
    plugins-conform-nvim = {
      url = "github:stevearc/conform.nvim";
      flake = false;
    };
    plugins-gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    plugins-live-preview-nvim = {
      url = "github:brianhuster/live-preview.nvim";
      flake = false;
    };
    plugins-render-markdown-nvim = {
      url = "github:MeanderingProgrammer/render-markdown.nvim";
      flake = false;
    };

    # UI Plugins
    plugins-noice-nvim = {
      url = "github:folke/noice.nvim";
      flake = false;
    };
    plugins-incline-nvim = {
      url = "github:b0o/incline.nvim";
      flake = false;
    };
    plugins-nvim-colorizer-lua = {
      url = "github:catgoose/nvim-colorizer.lua";
      flake = false;
    };

    # Misc Plugins
    plugins-mini-nvim = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };
    plugins-snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = ./.;
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

    extra_pkg_config = {};

    dependencyOverlays = [
      (utils.standardPluginOverlay inputs)
    ];

    categoryDefinitions = {pkgs, ...}: {
      lspsAndRuntimeDeps.packages = with pkgs; [
        # Runtime Dependencys
        fd
        fzf
        lazygit
        ripgrep
        stdenv.cc.cc

        # Bundles
        kdePackages.qtdeclarative
        llvmPackages_latest.clang-tools

        # Language Servers
        nixd
        hyprls
        emmylua-ls
        basedpyright
        rust-analyzer
        lua-language-server
        bash-language-server
        yaml-language-server
        emmet-language-server
        svelte-language-server
        typescript-language-server
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
        # ruff
        selene
        clippy
        cppcheck
        eslint_d
        stylelint
        shellcheck
      ];

      startupPlugins.packages = with pkgs.neovimPlugins; [
        # Libraries
        nui-nvim
        plenary-nvim
        nvim-lspconfig

        # Editor Plugins
        leap-nvim
        nvim-lint
        conform-nvim
        gitsigns-nvim
        live-preview-nvim
        render-markdown-nvim
        inputs.blink-pairs.packages.${pkgs.stdenv.hostPlatform.system}.blink-pairs
        inputs.nvim-treesitter-main.packages.${pkgs.stdenv.hostPlatform.system}.nvim-treesitter.withAllGrammars

        # UI Plugins
        noice-nvim
        incline-nvim
        nvim-colorizer-lua

        # Misc Plugins
        mini-nvim
        snacks-nvim
      ];
    };

    packageDefinitions = {
      nvim = {pkgs, ...}: {
        categories = {
          packages = true;
        };

        settings = {
          wrapRc = true;
          configDirName = "nixCats-nvim";
          aliases = [];

          neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
        };

        extra = {
          nixdExtras = {inherit nixpkgs;};
        };
      };

      regularCats = {pkgs, ...}: {
        categories = {
          packages = true;
        };

        settings = {
          wrapRc = false;
          configDirName = "nixCats-nvim";
          aliases = [];

          neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
        };

        extra = {
          nixdExtras = {inherit nixpkgs;};
        };
      };
    };

    defaultPackageName = "nvim";
  in
    forEachSystem (system: let
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;
      pkgs = import nixpkgs {inherit system;};
    in {
      packages = utils.mkAllWithDefault defaultPackage;

      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [defaultPackage];
          inputsFrom = [];
          shellHook = ''
          '';
        };
      };
    })
    // (let
      nixosModule = utils.mkNixosModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      homeModule = utils.mkHomeModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
    in {
      overlays =
        utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      nixosModules.default = nixosModule;
      homeModules.default = homeModule;

      inherit utils nixosModule homeModule;
      inherit (utils) templates;
    });
}
