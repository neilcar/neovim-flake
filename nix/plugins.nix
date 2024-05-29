{
  inputs,
  pkgs,
  opts,
}: let
  # Function to create a Neovim plugin from a flake input
  mkNvimPlugin = {
    src,
    pname,
  }:
    pkgs.vimUtils.buildNeovimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Merge nvim-treesitter parsers together to reduce vim.api.nvim_list_runtime_paths()
  nvim-treesitter-grammars = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };
in
  with pkgs.vimPlugins;
    [
      # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins

      # Plugins can also be lazy loaded with ':packadd! plugin-name' when optional is true:
      #{ plugin = luasnip; optional = true; }

      #nvim-treesitter.withAllGrammars
      nvim-treesitter
      nvim-treesitter-grammars
      nvim-treesitter-textobjects

      # format & linting
      conform-nvim
      nvim-lint

      # lsp
      nvim-lspconfig
      neodev-nvim

      # completion & snippets
      luasnip
      nvim-cmp
      cmp_luasnip
      lspkind-nvim
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp-cmdline
      cmp-cmdline-history

      neo-tree-nvim
      trouble-nvim
      undotree
      vim-sleuth
      aerial-nvim

      # telescope-nvim
      # telescope-zf-native-nvim

      # Dependencies
      plenary-nvim
      nvim-web-devicons
      vim-repeat

      # Plugins outside of nixpkgs
      (mkNvimPlugin {
        src = inputs.vim-varnish;
        pname = "vim-varnish";
      })
      (mkNvimPlugin {
        src = inputs.mini-nvim;
        pname = "mini-nvim";
      })
    ]
    ++ (pkgs.lib.optionals opts.withSQLite [sqlite-lua])
