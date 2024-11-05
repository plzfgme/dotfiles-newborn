return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = {},
        typst_lsp = {},
        elixirls = {
          cmd = { "elixir-ls" },
          filetypes = { "elixir" },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "nixpkgs_fmt" },
        typst = { "typstfmt" },
      },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        yaml = true,
      },
    },
  },
}
