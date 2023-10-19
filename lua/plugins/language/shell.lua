local stems = require("environment.keys").stems
local deflang = require('funsak.lazy').language

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
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
          opts.sources = vim.tbl_deep_extend("force", {
            require('nu-ls')
          }, opts.sources or {})
        end
      },
    },
  },
}
