{
  description = "Mevim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
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
    plugins-leap-nvim = {
      url = "git+https://codeberg.org/andyg/leap.nvim";
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

  outputs = {
    self,
    nixpkgs,
    wrappers,
    ...
  } @ inputs: let
    module = nixpkgs.lib.modules.importApply ./module.nix inputs;
    wrapper = wrappers.lib.evalModule module;

    eachSystem = f:
      nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all
      (system: f nixpkgs.legacyPackages.${system});
  in {
    overlays = {
      neovim = final: prev: {neovim = wrapper.config.wrap {pkgs = final;};};
      default = self.overlays.neovim;
    };

    wrapperModules = {
      neovim = module;
      default = self.wrapperModules.neovim;
    };

    wrappers = {
      neovim = wrapper.config;
      default = self.wrappers.neovim;
    };

    packages = eachSystem (
      pkgs: {
        neovim = wrapper.config.wrap {inherit pkgs;};
        dynamic = wrapper.config.wrap {
          inherit pkgs;
          settings.dynamic = true;
        };

        default = self.packages.${pkgs.stdenv.system}.neovim;
      }
    );
  };
}
