{
  description = "Mevim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-treesitter-main = {
      url = "github:iofq/nvim-treesitter-main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plugins
    plugins-oil = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = ./.;
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

    extra_pkg_config = {};

    dependencyOverlays = [
      (utils.standardPluginOverlay inputs)

      # Use the nvim-treesitter main branch version
      inputs.nvim-treesitter-main.overlays.default
      # (final: previous: {
      #   vimPlugins = previous.vimPlugins.extend (
      #     f: p: {
      #       nvim-treesitter-textobjects = p.nvim-treesitter-textobjects.overrideAttrs {
      #         dependencies = [ f.nvim-treesitter ];
      #       };
      #     }
      #   );
      # })
    ];

    categoryDefinitions = {pkgs, ...}: {
      lspsAndRuntimeDeps.packages = with pkgs; [
        # Runtime Dependencys
        fd
        fzf
        lazygit
        ripgrep
        stdenv.cc.cc

        # Language Servers
        nixd
        ruff
        hyprls
        pyright
        rust-analyzer
        lua-language-server
        bash-language-server
        yaml-language-server
        emmet-language-server
        svelte-language-server
        llvmPackages_latest.clang-tools
        typescript-language-server
        tailwindcss-language-server
        vscode-langservers-extracted

        # Formatters
        stylua
        alejandra
        rustfmt
      ];

      startupPlugins.packages = with pkgs.vimPlugins; [
        # Libraries
        nui-nvim
        plenary-nvim
        nvim-lspconfig

        # Movement Plugins
        leap-nvim

        # Code Plugins
        # neogit
        treesj
        blink-cmp
        blink-pairs
        lazydev-nvim
        conform-nvim
        render-markdown-nvim
        markdown-preview-nvim
        nvim-treesitter.withAllGrammars

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
