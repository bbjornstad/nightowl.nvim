local stems = require("environment.keys").stems
local key_neogen = stems.neogen

return {
  {
    "jghauser/auto-pandoc.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
    opts = {},
    keys = {
      {
        "<leader>Do",
        "<CMD>silent w<bar> lua require('auto-pandoc').run_pandoc()<CR>",
        mode = "n",
        desc = "docs=> convert with pandoc",
        buffer = 0,
        noremap = true,
        silent = true,
      },
    },
  },
  {
    "danymat/neogen",
    event = { "VeryLazy" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { snippet_engine = "luasnip" },
    keys = {
      {
        key_neogen .. "d",
        function()
          return require("neogen").generate({ type = "any" })
        end,
        mode = "n",
        desc = "gendoc=> generic docstring",
      },
      {
        key_neogen .. "c",
        function()
          return require("neogen").generate({ type = "class" })
        end,
        mode = "n",
        desc = "gendoc=> class/obj docstring",
      },
      {
        key_neogen .. "t",
        function()
          return require("neogen").generate({ type = "type" })
        end,
        mode = "n",
        desc = "gendoc=> type docstring",
      },
      {
        key_neogen .. "f",
        function()
          return require("neogen").generate({ type = "func" })
        end,
        mode = "n",
        desc = "gendoc=> function docstring",
      },
    },
  },
}
