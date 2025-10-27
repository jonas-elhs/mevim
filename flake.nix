{
  description = "Mevim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
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
        ripgrep
        fd
        fzf
        stdenv.cc.cc
      ];

      startupPlugins.packages = with pkgs.vimPlugins; [
        lze
        nvim-web-devicons
        plenary-nvim
        nui-nvim
      ];

      optionalPlugins.packages = with pkgs.vimPlugins; [
        oil-nvim
        leap-nvim

        nvim-ufo
        gitsigns-nvim
        neogit
        hardtime-nvim
        nvim-surround
        treesj
        nvim-treesitter.withAllGrammars

        blink-cmp
        blink-ripgrep-nvim

        lazydev-nvim

        ccc-nvim
        incline-nvim
        helpview-nvim
        snacks-nvim
        noice-nvim
      ];

      sharedLibraries = {};
      environmentVariables = {};
      extraWrapperArgs = {};

      extraLuaPackages = {
        general = [ (_:[]) ];
      };

      extraCats = {};
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
        };

        extra = {
          nixdExtras = { nixpkgs = nixpkgs; };
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
