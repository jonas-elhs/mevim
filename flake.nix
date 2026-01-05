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

    plugins-mini-nvim = {
      url = "github:nvim-mini/mini.nvim";
      flake = false;
    };
    plugins-nvim-lint = {
      url = "github:mfussenegger/nvim-lint";
      flake = false;
    };
    plugins-snap-nvim = {
      url = "github:mistweaverco/snap.nvim";
      flake = false;
    };
    plugins-noice-nvim = {
      url = "github:folke/noice.nvim";
      flake = false;
    };
    plugins-treesj-nvim = {
      url = "github:Wansmer/treesj";
      flake = false;
    };
    plugins-snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
    plugins-incline-nvim = {
      url = "github:b0o/incline.nvim";
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
    plugins-markview-nvim = {
      url = "github:OXY2DEV/markview.nvim";
      flake = false;
    };
    plugins-live-preview-nvim = {
      url = "github:brianhuster/live-preview.nvim";
      flake = false;
    };
    plugins-nvim-colorizer-lua = {
      url = "github:catgoose/nvim-colorizer.lua";
      flake = false;
    };
    plugins-colorful-winsep-nvim = {
      url = "github:nvim-zh/colorful-winsep.nvim";
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
      lspsAndRuntimeDeps.all = with pkgs; [
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
        # ruff
        statix
        selene
        clippy
        cppcheck
        eslint_d
        stylelint
        shellcheck
      ];

      startupPlugins.all = with pkgs.neovimPlugins; [
        nui-nvim
        plenary-nvim
        nvim-lspconfig

        nvim-lint
        mini-nvim
        # snap-nvim
        noice-nvim
        treesj-nvim
        snacks-nvim
        incline-nvim
        conform-nvim
        gitsigns-nvim
        markview-nvim
        live-preview-nvim
        nvim-colorizer-lua
        colorful-winsep-nvim
        inputs.nvim-treesitter-main.packages.${pkgs.stdenv.hostPlatform.system}.nvim-treesitter.withAllGrammars
      ];
    };

    packageDefinitions = {
      nvim = {pkgs, ...}: {
        categories = {
          all = true;
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
          all = true;
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
