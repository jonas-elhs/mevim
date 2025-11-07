{
  description = "Mevim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    plugins-colorful-winsep = {
      url = "github:nvim-zh/colorful-winsep.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = ./.;
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

    extra_pkg_config = {
      # allowUnfree = true;
    };

    dependencyOverlays = [
      (utils.standardPluginOverlay inputs)
    ];

    categoryDefinitions = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
      lspsAndRuntimeDeps.packages = with pkgs; [
        # Runtime Dependencys
        fd
        fzf
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
      ];

      startupPlugins.packages = with pkgs.vimPlugins; [
        # Startup Plugins
        lze
        nui-nvim
        plenary-nvim
        nvim-lspconfig
      ];

      optionalPlugins.packages = with pkgs.vimPlugins; [
        # Movement Plugins
        oil-nvim
        leap-nvim

        # Code Plugins
        neogit
        blink-cmp
        lazydev-nvim
        gitsigns-nvim
        hardtime-nvim
        nvim-surround
        render-markdown-nvim
        markdown-preview-nvim
        nvim-treesitter.withAllGrammars

        # UI Plugins
        noice-nvim
        incline-nvim
        virt-column-nvim
        nvim-colorizer-lua
        pkgs.neovimPlugins.colorful-winsep

        # Misc Plugins
        mini-move
        mini-icons
        snacks-nvim
        mini-surround
        mini-splitjoin
      ];
    };

    packageDefinitions = {
      nvim = { pkgs, name, ... }@misc: {
        categories = {
          packages = true;
        };

        settings = {
          wrapRc = true;
          configDirName = "nixCats-nvim";
          aliases = [];

          neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
        };

        extra = {
          nixdExtras = { inherit nixpkgs; };
        };
      };

      regularCats = { pkgs, ... }@misc: {
        categories = {
          packages = true;
        };

        settings = {
          wrapRc = false;
          configDirName = "nixCats-nvim";
          aliases = [ ];

          neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
        };

        extra = {
          nixdExtras = { inherit nixpkgs; };
        };
      };
    };

    defaultPackageName = "nvim";
  in
  forEachSystem (system: let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;

    pkgs = import nixpkgs { inherit system; };
  in {
    packages = utils.mkAllWithDefault defaultPackage;

    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };

  }) // (let
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
  in {
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  });
}
