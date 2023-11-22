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
    config = true,
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
        ft = { "nu" },
        config = function(_, opts)
          vim.filetype.add({
            extension = {
              nu = "nu",
            },
          })
          require("nu-ls").setup(opts)
        end,
        opts = {},
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvimtools/none-ls.nvim",
        },
      },
    },
  },
  {
    "zioroboco/nu-ls.nvim",
  },
}
