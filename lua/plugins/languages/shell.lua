local stems = require("environment.keys").stems

return {
  {
    "LhKipp/nvim-nu",
    build = ":TSInstall nu",
    ft = { "nu" },
    opts = {
      use_lsp_features = true,
      all_cmd_names = [[nu -c 'help commands | get name | str join "\n"']],
    },
    init = function()
      vim.filetype.add({
        extension = {
          nu = "nu",
        },
      })
    end,
    config = true,
  },
  -- {
  --   "zioroboco/nu-ls.nvim",
  --   ft = { "nu" },
  --   config = function(_, opts)
  --     require("nu-ls").setup(opts)
  --   end,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     {
  --       "jose-elias-alvarez/null-ls.nvim",
  --       opts = {
  --         sources = {
  --           require("nu-ls"),
  --         },
  --       },
  --     },
  --   },
  -- },
}
