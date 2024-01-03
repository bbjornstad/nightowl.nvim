local lsp = require("funsak.lsp")
local lopts = require("funsak.table").lopts

return {
  {
    "LhKipp/nvim-nu",
    dependencies = {
      "zioroboco/nu-ls.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    build = ":TSInstall nu",
    ft = { "nu" },
    opts = {
      use_lsp_features = true,
      all_cmd_names = [[nu -c 'help commands | get name | str join "\n"']],
    },
    config = function(_, opts)
      require("nu").setup(opts)
      vim.filetype.add({
        extension = {
          nu = "nu",
        },
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      opts.sources = lopts({
        require("nu-ls"),
      }, opts.sources or {})
    end,
    dependencies = {
      {
        "zioroboco/nu-ls.nvim",
      },
    },
    ft = { "nu" },
  },
  {
    "zioroboco/nu-ls.nvim",
    ft = { "nu" },
    config = function(_, opts)
      require("nu-ls").setup(opts)
    end,
    opts = {
      debounce = 500,
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvimtools/none-ls.nvim" },
    },
  },
  lsp.server("bashls", { server = {} }),
  lsp.formatters({ bash = { "shellharden", "shfmt", "beautysh" } }),
  lsp.formatters({ zsh = { "beautysh" } }),
  lsp.linters({ bash = { "shellcheck" } }),
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      opts.enabled = vim.tbl_deep_extend("force", opts.enabled or {}, {
        filetypes = { "nu" },
      })
    end,
  },
}
