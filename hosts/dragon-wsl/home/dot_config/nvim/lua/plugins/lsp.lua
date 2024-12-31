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
        clojure_lsp = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "nixpkgs_fmt" },
        typst = { "typstfmt" },
        ocaml = { "ocamlformat" },
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
