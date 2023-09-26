local stems = require("environment.keys").stems

return {
  {
    "LhKipp/nvim-nu",
    dependencies = {
      "zioroboco/nu-ls.nvim",
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
    "zioroboco/nu-ls.nvim",
    ft = { "nu" },
    init = function()
      vim.filetype.add({
        extension = {
          nu = "nu",
        },
      })
    end,

    config = function(_, opts)
      require("nu-ls").setup(opts)
      require('null-ls').setup({
        sources = {
          require('nu-ls'),
        }
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
  },
}
